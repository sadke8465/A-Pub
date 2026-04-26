import UIKit
import WebKit
import SwiftUI

// MARK: - EPUBPageContentViewController

/// One slot in the three-element WKWebView pool.  Each slot owns an
/// independent ``WKWebView`` and ``EPUBBridge``.  All slots load the same
/// EPUB so adjacent pages can be pre-rendered before the user reaches them.
@MainActor
final class EPUBPageContentViewController: UIViewController, WKNavigationDelegate {

    let bridge: EPUBBridge
    private(set) var webView: WKWebView!
    let slotIndex: Int
    private var hasMarkedReady = false
    var onReaderHTMLReady: ((Int) -> Void)?
    var onWebContentTerminated: ((Int) -> Void)?

    init(slotIndex: Int) {
        self.slotIndex = slotIndex
        bridge = EPUBBridge()
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 248.0 / 255.0, alpha: 1.0)
        view.isOpaque = true
        let config = bridge.setup()
        config.setURLSchemeHandler(EPUBFileSchemeHandler.shared, forURLScheme: EPUBFileSchemeHandler.scheme)
        let viewportSource = "var m=document.createElement('meta');m.name='viewport';m.content='width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no';document.head.appendChild(m);"
        config.userContentController.addUserScript(
            WKUserScript(source: viewportSource, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        )
        webView = WKWebView(frame: view.bounds, configuration: config)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.minimumZoomScale = 1.0
        webView.scrollView.maximumZoomScale = 1.0
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.navigationDelegate = self
        bridge.webView = webView
        view.addSubview(webView)

        guard let htmlURL = Bundle.main.url(forResource: "reader", withExtension: "html") else {
            Log.shared.error("reader.html missing from app bundle")
            return
        }
        webView.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL.deletingLastPathComponent())
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard !hasMarkedReady, webView.url?.lastPathComponent == "reader.html" else { return }
        hasMarkedReady = true
        onReaderHTMLReady?(slotIndex)
    }

    func updateLayoutFrame(_ bounds: CGRect) {
        view.frame = bounds
        webView?.frame = view.bounds
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        Log.shared.error("PageCurl slot \(slotIndex) WebContent process terminated")
        hasMarkedReady = false
        onWebContentTerminated?(slotIndex)
        webView.reload()
    }
}

// MARK: - PageCurlViewController

/// `UIPageViewController` that provides an Apple-Books–style page-curl
/// animation by cycling three ``EPUBPageContentViewController`` pool slots
/// (previous / current / next).  Swift drives each slot's epub.js rendition
/// via ``callJS(_:)``; UIKit owns the curl gesture and transition timing.
@MainActor
final class PageCurlViewController: UIPageViewController, UIGestureRecognizerDelegate {

    private enum SlotLifecycleState: Equatable {
        case htmlLoading
        case htmlLoaded
        case bookLoading(token: Int)
        case bookReady(token: Int)
        case failed(token: Int, error: String)

        var label: String {
            switch self {
            case .htmlLoading: return "htmlLoading"
            case .htmlLoaded: return "htmlLoaded"
            case .bookLoading: return "bookLoading"
            case .bookReady: return "bookReady"
            case .failed: return "failed"
            }
        }

        var token: Int? {
            switch self {
            case .bookLoading(let token), .bookReady(let token), .failed(let token, _):
                return token
            case .htmlLoading, .htmlLoaded:
                return nil
            }
        }
    }

    private enum CommandFamily: String {
        case navigation
        case appearance
        case load
        case display
    }

    private enum PreparedSlotDirection: String {
        case previous = "prev"
        case next = "next"

        var pageTurnDirection: UIPageViewController.NavigationDirection {
            switch self {
            case .previous: return .reverse
            case .next: return .forward
            }
        }

        var jsStep: String { rawValue }
    }

    private struct PendingCommand {
        let js: String
        let family: CommandFamily
        let token: Int
    }

    // pool[poolCurrent]       = current (visible)
    // pool[(poolCurrent+2)%3] = previous
    // pool[(poolCurrent+1)%3] = next
    private let pool: [EPUBPageContentViewController]
    private var poolCurrent = 1
    private var slotState = [SlotLifecycleState](repeating: .htmlLoading, count: 3)
    private var isHTMLReadyBySlot = [Bool](repeating: false, count: 3)
    private var loadTokenBySlot = [Int](repeating: 0, count: 3)
    private var queuedCommandsBySlot = [[PendingCommand]](repeating: [], count: 3)
    private struct PendingLoad {
        let bookURLString: String
        let fallbackEscapedBase64: String?
    }
    private var pendingLoadBySlot = [PendingLoad?](repeating: nil, count: 3)
    private var activeLoad: PendingLoad?
    private var hasLoadedAdjacentSlots = false
    private let isSingleSlotPagingEnabled = false
    private var currentLocation: EPUBBridge.RelocatedEvent?
    private var lastLocationBySlot = [EPUBBridge.RelocatedEvent?](repeating: nil, count: 3)
    private var preparedBaseCFIBySlot = [String?](repeating: nil, count: 3)
    private var preparedDirectionBySlot = [PreparedSlotDirection?](repeating: nil, count: 3)
    private var pendingPrepareBaseCFIBySlot = [String?](repeating: nil, count: 3)
    private var pendingPrepareDirectionBySlot = [PreparedSlotDirection?](repeating: nil, count: 3)
    private var isProgrammaticTurnInFlight = false
    private var isReaderInteractionBlocked = false
    private var isRightToLeftReading = false
    private var isReduceMotionEnabled = UIAccessibility.isReduceMotionEnabled
    private let prewarmContainer = UIView(frame: .zero)

    var currentSlot: EPUBPageContentViewController { pool[poolCurrent] }
    var prevSlot:    EPUBPageContentViewController { pool[(poolCurrent + 2) % 3] }
    var nextSlot:    EPUBPageContentViewController { pool[(poolCurrent + 1) % 3] }

    // Callbacks forwarded from the current slot's bridge.
    var onRelocated:         ((String, Double, String, Int64, String) -> Void)?
    var onBookReady:         (() -> Void)?
    var onBookError:         ((String) -> Void)?
    var onSelected:          ((String, String) -> Void)?
    var onMarkClicked:       ((String) -> Void)?
    var onRequestHighlights: ((String) -> Void)?
    var onFootnoteRequest: ((String, String) -> Void)?
    var onAtChapterEnd:      (() -> Void)?
    var onLocationsSnapshot: ((Int, String?) -> Void)?
    var onWordCountSample: (([Int]) -> Void)?
    var onChapterWordCount: ((Int, Int) -> Void)?
    var onJavaScriptExecutionFailed: ((EPUBBridge.JavaScriptExecutionFailure) -> Void)?
    var onJSGuardBlocked: ((Int, EPUBBridge.JSGuardBlockedEvent) -> Void)?
    var onRenderState: ((Int, EPUBBridge.RenderStateEvent) -> Void)?
    var onFirstContentReady: ((Int, EPUBBridge.FirstContentReadyEvent) -> Void)?
    var onCenterTap: (() -> Void)?

    // MARK: Init

    init() {
        pool = (0..<3).map { EPUBPageContentViewController(slotIndex: $0) }
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = isSingleSlotPagingEnabled ? nil : self
        delegate = self
        prewarmContainer.isUserInteractionEnabled = false
        prewarmContainer.backgroundColor = .clear
        prewarmContainer.alpha = 1.0
        view.insertSubview(prewarmContainer, at: 0)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleReaderTap(_:)))
        tapRecognizer.cancelsTouchesInView = false
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
        pool.forEach { slot in
            slot.onReaderHTMLReady = { [weak self] index in
                self?.markSlotReady(index)
            }
            slot.onWebContentTerminated = { [weak self] index in
                self?.handleWebContentTerminated(for: index)
            }
        }
        setViewControllers([currentSlot], direction: .forward, animated: false)
        wireCurrentSlotCallbacks()
        wireBridgeFailureCallbacks()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        prewarmContainer.frame = view.bounds
        view.sendSubviewToBack(prewarmContainer)
        pool.forEach { slot in
            guard slot.isViewLoaded else { return }
            let bounds = slot.view.superview === prewarmContainer ? prewarmContainer.bounds : view.bounds
            slot.updateLayoutFrame(bounds)
        }
    }

    @objc private func handleReaderTap(_ recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .ended, !isReaderInteractionBlocked else {
            return
        }

        let location = recognizer.location(in: view)
        let width = view.bounds.width
        if location.x < width * 0.25 {
            isRightToLeftReading ? turnForward() : turnBackward()
        } else if location.x > width * 0.75 {
            isRightToLeftReading ? turnBackward() : turnForward()
        } else {
            onCenterTap?()
        }
    }

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }

    // MARK: Public API

    /// Load the current slot first. Adjacent slots are prewarmed after the
    /// visible slot proves it can render and relocate.
    func loadBook(fileURL: URL, fallbackEscapedBase64: String? = nil) {
        let bridgedURLString = EPUBFileSchemeHandler.shared.register(fileURL: fileURL).absoluteString
        let load = PendingLoad(
            bookURLString: bridgedURLString,
            fallbackEscapedBase64: fallbackEscapedBase64
        )
        activeLoad = load
        hasLoadedAdjacentSlots = false
        currentLocation = nil
        lastLocationBySlot = [EPUBBridge.RelocatedEvent?](repeating: nil, count: pool.count)
        invalidatePreparedSlots()
        for slotIndex in pool.indices where slotIndex != poolCurrent {
            queuedCommandsBySlot[slotIndex].removeAll()
            pendingLoadBySlot[slotIndex] = nil
            if isHTMLReadyBySlot[slotIndex] {
                slotState[slotIndex] = .htmlLoaded
            }
        }
        queueLoadIfNeeded(slotIndex: poolCurrent, load: load)
    }

    func displayCFI(_ cfi: String) {
        invalidatePreparedSlots()
        enqueueOrDispatch(slotIndex: poolCurrent, js: "displayCFI(\(Self.jsStringLiteral(cfi)))", family: .display)
    }

    func displayHref(_ href: String) {
        invalidatePreparedSlots()
        enqueueOrDispatch(slotIndex: poolCurrent, js: "displayHref(\(Self.jsStringLiteral(href)))", family: .display)
    }

    func displayPercentage(_ percentage: Double) {
        invalidatePreparedSlots()
        enqueueOrDispatch(slotIndex: poolCurrent, js: "displayCFI(\(percentage))", family: .display)
    }

    func setReaderInteractionBlocked(_ blocked: Bool) {
        isReaderInteractionBlocked = blocked
    }

    func setRightToLeftReading(_ isRightToLeft: Bool) {
        guard isRightToLeftReading != isRightToLeft else {
            return
        }
        isRightToLeftReading = isRightToLeft
        invalidatePreparedSlots()
        syncAdjacentSlots(reason: "readingDirection")
    }

    func setReduceMotionEnabled(_ reduceMotion: Bool) {
        isReduceMotionEnabled = reduceMotion
    }

    func requestChapterWordCount(_ index: Int) {
        enqueueOrDispatch(slotIndex: poolCurrent, js: "requestChapterWordCount(\(index))", family: .display)
    }

    func requestLocationsSnapshot() {
        enqueueOrDispatch(slotIndex: poolCurrent, js: "snapshotLocations()", family: .display)
    }

    /// Forward a JavaScript call to the current slot's rendition.
    func callJS(_ js: String) {
        enqueueOrDispatch(slotIndex: poolCurrent, js: js, family: commandFamily(for: js))
    }

    func turnForward() {
        guard !isReaderInteractionBlocked else {
            return
        }
        Log.shared.debug("PageCurl turnForward slot=\(poolCurrent) singleSlot=\(isSingleSlotPagingEnabled)")
        guard !isSingleSlotPagingEnabled else {
            enqueueOrDispatch(slotIndex: poolCurrent, js: "nextPage()", family: .navigation)
            return
        }
        performPreparedTurn(.next)
    }

    func turnBackward() {
        guard !isReaderInteractionBlocked else {
            return
        }
        Log.shared.debug("PageCurl turnBackward slot=\(poolCurrent) singleSlot=\(isSingleSlotPagingEnabled)")
        guard !isSingleSlotPagingEnabled else {
            enqueueOrDispatch(slotIndex: poolCurrent, js: "prevPage()", family: .navigation)
            return
        }
        performPreparedTurn(.previous)
    }

    private func performPreparedTurn(_ direction: PreparedSlotDirection) {
        let targetSlot = direction == .next ? nextSlot : prevSlot
        guard isSlotPrepared(targetSlot.slotIndex, for: direction) else {
            Log.shared.debug(
                "PageCurl adjacent slot \(targetSlot.slotIndex) not prepared for \(direction.rawValue); falling back to current-slot JS"
            )
            let js = direction == .next ? "nextPage()" : "prevPage()"
            invalidatePreparedSlots()
            enqueueOrDispatch(slotIndex: poolCurrent, js: js, family: .navigation)
            return
        }

        isProgrammaticTurnInFlight = true
        detachFromPrewarmIfNeeded(targetSlot.slotIndex)
        setViewControllers(
            [targetSlot],
            direction: pageTurnDirection(for: direction),
            animated: !isReduceMotionEnabled
        ) { [weak self, weak targetSlot] completed in
            guard let self, let targetSlot else { return }
            self.isProgrammaticTurnInFlight = false
            if completed {
                self.completePageCurlTransition(to: targetSlot, direction: direction)
            } else {
                self.syncAdjacentSlots(reason: "programmaticTurnCancelled:\(direction.rawValue)")
            }
        }
    }

    private func pageTurnDirection(for direction: PreparedSlotDirection) -> UIPageViewController.NavigationDirection {
        guard isRightToLeftReading else {
            return direction.pageTurnDirection
        }
        return direction == .next ? .reverse : .forward
    }

    func applyAppearance(_ appearance: ReaderAppearance) {
        applyTheme(appearance.theme)
        applyFontSize(Int(appearance.fontSize))
        applyFontFamily(appearance.fontFamily)
        applyLineSpacing(appearance.lineSpacing)
        applyMargin(Self.marginPixels(for: appearance.marginStyle))
        applyJustify(appearance.textAlignment == "justify")
        applyHyphenation(appearance.hyphenation)
    }

    func applyTheme(_ theme: String) {
        let escaped = theme.replacingOccurrences(of: "'", with: "\\'")
        broadcastAppearance("setTheme('\(escaped)')")
    }

    func applyFontSize(_ px: Int) {
        broadcastAppearance("setFontSize(\(px))")
    }

    func applyFontFamily(_ family: String) {
        let escaped = family.replacingOccurrences(of: "'", with: "\\'")
        broadcastAppearance("setFontFamily('\(escaped)')")
    }

    func applyLineSpacing(_ value: Double) {
        broadcastAppearance("setLineSpacing(\(value))")
    }

    func applyMargin(_ px: Int) {
        broadcastAppearance("setMargin(\(px))")
    }

    func applyJustify(_ justify: Bool) {
        broadcastAppearance("setJustify(\(justify))")
    }

    func applyHyphenation(_ on: Bool) {
        broadcastAppearance("setHyphenation(\(on))")
    }

    private func broadcastAppearance(_ js: String) {
        invalidatePreparedSlots()
        let targetSlots = isSingleSlotPagingEnabled ? [poolCurrent] : Array(pool.indices)
        for slotIndex in targetSlots {
            enqueueOrDispatch(slotIndex: slotIndex, js: js, family: .appearance)
        }
        syncAdjacentSlots(reason: "appearance")
    }

    static func marginPixels(for style: String) -> Int {
        switch style {
        case "narrow": return 8
        case "wide": return 40
        default: return 24
        }
    }

    /// Tear down all pool bridges (call from `dismantleUIViewController`).
    func invalidatePool() {
        pool.forEach { $0.bridge.invalidate() }
    }

    // MARK: Callback wiring

    private func wireCurrentSlotCallbacks() {
        let slot = currentSlot
        slot.bridge.onBookError         = { [weak self] msg  in self?.onBookError?(msg) }
        slot.bridge.onSelected          = { [weak self] r, t in self?.onSelected?(r, t) }
        slot.bridge.onMarkClicked       = { [weak self] id   in self?.onMarkClicked?(id) }
        slot.bridge.onRequestHighlights = { [weak self] href in self?.onRequestHighlights?(href) }
        slot.bridge.onFootnoteRequest = { [weak self] href, text in
            self?.onFootnoteRequest?(href, text)
        }
        slot.bridge.onAtChapterEnd      = { [weak self] in
            self?.onAtChapterEnd?()
        }
        slot.bridge.onLocationsSnapshot = { [weak self] total, serialized in
            self?.onLocationsSnapshot?(total, serialized)
        }
        slot.bridge.onWordCountSample = { [weak self] counts in
            self?.onWordCountSample?(counts)
        }
        slot.bridge.onChapterWordCount = { [weak self] index, count in
            self?.onChapterWordCount?(index, count)
        }
    }

    private func wireBridgeFailureCallbacks() {
        pool.forEach { slot in
            slot.bridge.onRelocatedEvent = { [weak self] event in
                self?.handleRelocated(event, for: slot.slotIndex)
            }
            slot.bridge.onBookReady = { [weak self] in
                self?.handleBookReady(for: slot.slotIndex)
            }
            slot.bridge.onBookError = { [weak self] message in
                self?.handleBookError(for: slot.slotIndex, message: message)
            }
            slot.bridge.onJSGuardBlocked = { [weak self] event in
                self?.onJSGuardBlocked?(slot.slotIndex, event)
            }
            slot.bridge.onJavaScriptExecutionFailed = { [weak self] failure in
                self?.onJavaScriptExecutionFailed?(failure)
            }
            slot.bridge.onRenderState = { [weak self] event in
                self?.handleRenderState(event, for: slot.slotIndex)
            }
            slot.bridge.onFirstContentReady = { [weak self] event in
                self?.handleFirstContentReady(event, for: slot.slotIndex)
            }
        }
    }

    private func clearCurrentSlotCallbacks() {
        let slot = currentSlot
        slot.bridge.onBookReady         = { [weak self] in
            self?.handleBookReady(for: slot.slotIndex)
        }
        slot.bridge.onBookError         = { [weak self] msg in
            self?.handleBookError(for: slot.slotIndex, message: msg)
        }
        slot.bridge.onSelected          = nil
        slot.bridge.onMarkClicked       = nil
        slot.bridge.onRequestHighlights = nil
        slot.bridge.onFootnoteRequest   = nil
        slot.bridge.onAtChapterEnd      = nil
        slot.bridge.onLocationsSnapshot = nil
        slot.bridge.onWordCountSample = nil
        slot.bridge.onChapterWordCount = nil
    }

    // MARK: Pool rotation

    private func markSlotReady(_ slotIndex: Int) {
        isHTMLReadyBySlot[slotIndex] = true
        switch slotState[slotIndex] {
        case .htmlLoading:
            slotState[slotIndex] = .htmlLoaded
        case .htmlLoaded, .bookLoading, .bookReady, .failed:
            // Preserve any later lifecycle state already reached. In particular,
            // do not regress `.bookLoading(token:)` set by `queueLoadIfNeeded`
            // back to `.htmlLoaded` — `flushPendingLoad` requires `.bookLoading`.
            break
        }
        Log.shared.debug("PageCurl slot \(slotIndex) htmlReady=true state=\(slotState[slotIndex].label)")
        flushPendingLoad(for: slotIndex)
    }

    private func queueLoadIfNeeded(slotIndex: Int, load: PendingLoad) {
        loadTokenBySlot[slotIndex] += 1
        let token = loadTokenBySlot[slotIndex]
        queuedCommandsBySlot[slotIndex] = queuedCommandsBySlot[slotIndex].filter { command in
            command.family == .appearance && command.token == 0
        }
        slotState[slotIndex] = .bookLoading(token: token)
        pendingLoadBySlot[slotIndex] = load
        Log.shared.debug("PageCurl slot \(slotIndex) state=\(slotState[slotIndex].label) token=\(token)")
        flushPendingLoad(for: slotIndex)
    }

    private func flushPendingLoad(for slotIndex: Int) {
        guard isHTMLReadyBySlot[slotIndex],
              case .bookLoading(let token) = slotState[slotIndex],
              let pendingLoad = pendingLoadBySlot[slotIndex]
        else { return }
        pendingLoadBySlot[slotIndex] = nil
        let host = URL(string: pendingLoad.bookURLString)?.host ?? "unknown"
        Log.shared.debug(
            "PageCurl slot \(slotIndex) load dispatched token=\(token) host=\(host)"
        )
        let js = "loadBook('\(pendingLoad.bookURLString)', \(pendingLoad.fallbackEscapedBase64.map { "'\($0)'" } ?? "null"))"
        pool[slotIndex].bridge.callJS(
            js,
            slotIndex: slotIndex,
            slotState: slotState[slotIndex].label,
            loadToken: token,
            commandFamily: CommandFamily.load.rawValue
        )
    }

    private func handleBookReady(for slotIndex: Int) {
        guard case .bookLoading(let token) = slotState[slotIndex], token == loadTokenBySlot[slotIndex] else {
            return
        }
        slotState[slotIndex] = .bookReady(token: token)
        Log.shared.debug("PageCurl slot \(slotIndex) state=bookReady token=\(token)")
        flushQueuedCommands(for: slotIndex)
        if slotIndex == poolCurrent {
            loadAdjacentSlotsIfNeeded(reason: "bookReady")
            onBookReady?()
        } else {
            syncAdjacentSlots(reason: "slotBookReady:\(slotIndex)")
        }
    }

    private func handleBookError(for slotIndex: Int, message: String) {
        let token = loadTokenBySlot[slotIndex]
        slotState[slotIndex] = .failed(token: token, error: message)
        queuedCommandsBySlot[slotIndex].removeAll()
        if slotIndex == poolCurrent {
            onBookError?(message)
        }
    }

    private func handleRelocated(_ event: EPUBBridge.RelocatedEvent, for slotIndex: Int) {
        lastLocationBySlot[slotIndex] = event

        if slotIndex == poolCurrent {
            currentLocation = event
            Log.shared.debug(
                """
                PageCurl currentSlotRelocated slot=\(slotIndex) source=\(event.source) \
                spine=\(event.spineIndex):\(event.spineHref) page=\(event.displayedPage ?? 0)/\(event.displayedTotal ?? 0)
                """
            )
            loadAdjacentSlotsIfNeeded(reason: "relocated")
            onRelocated?(
                event.cfi,
                event.percentage,
                event.spineHref,
                event.characterOffset,
                event.contextSnippet
            )
            syncAdjacentSlots(reason: "currentRelocated:\(event.source)")
            return
        }

        if let pendingDirection = pendingPrepareDirectionBySlot[slotIndex],
           let pendingBaseCFI = pendingPrepareBaseCFIBySlot[slotIndex],
           event.source == "afterDisplayAndStep:\(pendingDirection.jsStep)" {
            preparedBaseCFIBySlot[slotIndex] = pendingBaseCFI
            preparedDirectionBySlot[slotIndex] = pendingDirection
            pendingPrepareBaseCFIBySlot[slotIndex] = nil
            pendingPrepareDirectionBySlot[slotIndex] = nil
            Log.shared.debug(
                """
                PageCurl prepared slot=\(slotIndex) direction=\(pendingDirection.rawValue) \
                source=\(event.source) page=\(event.displayedPage ?? 0)/\(event.displayedTotal ?? 0)
                """
            )
        } else {
            Log.shared.debug(
                """
                PageCurl prewarmSlotRelocated slot=\(slotIndex) source=\(event.source) \
                spine=\(event.spineIndex):\(event.spineHref)
                """
            )
        }
    }

    private func loadAdjacentSlotsIfNeeded(reason: String) {
        guard !isSingleSlotPagingEnabled else {
            return
        }
        guard !hasLoadedAdjacentSlots, let activeLoad else {
            return
        }

        hasLoadedAdjacentSlots = true
        Log.shared.debug("PageCurl loading adjacent slots after \(reason)")
        for slotIndex in [prevSlot.slotIndex, nextSlot.slotIndex] where slotIndex != poolCurrent {
            loadAndSizeSlot(slotIndex)
            queueLoadIfNeeded(slotIndex: slotIndex, load: activeLoad)
        }
    }

    private func loadAndSizeSlot(_ slotIndex: Int) {
        let slot = pool[slotIndex]
        slot.loadViewIfNeeded()
        if slot.view.superview == nil {
            prewarmContainer.addSubview(slot.view)
        }
        view.sendSubviewToBack(prewarmContainer)
        let targetBounds = slot.view.superview === prewarmContainer ? prewarmContainer.bounds : view.bounds
        slot.updateLayoutFrame(targetBounds.isEmpty ? view.bounds : targetBounds)
        Log.shared.debug(
            "PageCurl slot \(slotIndex) view attached for prewarm bounds=\(Int(slot.view.bounds.width))x\(Int(slot.view.bounds.height))"
        )
    }

    private func detachFromPrewarmIfNeeded(_ slotIndex: Int) {
        let slot = pool[slotIndex]
        guard slot.isViewLoaded,
              slot.view.superview === prewarmContainer
        else {
            return
        }
        slot.view.removeFromSuperview()
        Log.shared.debug("PageCurl slot \(slotIndex) detached from prewarm for transition")
    }

    private func syncAdjacentSlots(reason: String) {
        guard !isSingleSlotPagingEnabled,
              let currentLocation,
              !currentLocation.cfi.isEmpty
        else {
            return
        }

        prepareAdjacentSlot(prevSlot.slotIndex, direction: .previous, baseCFI: currentLocation.cfi, reason: reason)
        prepareAdjacentSlot(nextSlot.slotIndex, direction: .next, baseCFI: currentLocation.cfi, reason: reason)
    }

    private func prepareAdjacentSlot(
        _ slotIndex: Int,
        direction: PreparedSlotDirection,
        baseCFI: String,
        reason: String
    ) {
        guard slotIndex != poolCurrent else {
            return
        }

        guard case .bookReady = slotState[slotIndex] else {
            return
        }

        loadAndSizeSlot(slotIndex)

        if preparedBaseCFIBySlot[slotIndex] == baseCFI,
           preparedDirectionBySlot[slotIndex] == direction {
            return
        }

        preparedBaseCFIBySlot[slotIndex] = nil
        preparedDirectionBySlot[slotIndex] = nil
        pendingPrepareBaseCFIBySlot[slotIndex] = baseCFI
        pendingPrepareDirectionBySlot[slotIndex] = direction

        let js = "displayAndStep(\(Self.jsStringLiteral(baseCFI)), \(Self.jsStringLiteral(direction.jsStep)))"
        Log.shared.debug(
            "PageCurl preparing slot \(slotIndex) direction=\(direction.rawValue) reason=\(reason)"
        )
        enqueueOrDispatch(slotIndex: slotIndex, js: js, family: .navigation)
    }

    private func isSlotPrepared(_ slotIndex: Int, for direction: PreparedSlotDirection) -> Bool {
        guard !isSingleSlotPagingEnabled,
              case .bookReady = slotState[slotIndex],
              let currentLocation,
              !currentLocation.cfi.isEmpty
        else {
            return false
        }

        return preparedBaseCFIBySlot[slotIndex] == currentLocation.cfi
            && preparedDirectionBySlot[slotIndex] == direction
            && lastLocationBySlot[slotIndex] != nil
    }

    private func invalidatePreparedSlots() {
        preparedBaseCFIBySlot = [String?](repeating: nil, count: pool.count)
        preparedDirectionBySlot = [PreparedSlotDirection?](repeating: nil, count: pool.count)
        pendingPrepareBaseCFIBySlot = [String?](repeating: nil, count: pool.count)
        pendingPrepareDirectionBySlot = [PreparedSlotDirection?](repeating: nil, count: pool.count)
    }

    private func completePageCurlTransition(
        to appearingSlot: EPUBPageContentViewController,
        direction: PreparedSlotDirection
    ) {
        let oldCurrent = poolCurrent
        guard appearingSlot.slotIndex != poolCurrent else {
            return
        }

        clearCurrentSlotCallbacks()
        poolCurrent = appearingSlot.slotIndex
        wireCurrentSlotCallbacks()

        if let adoptedLocation = lastLocationBySlot[poolCurrent] {
            currentLocation = adoptedLocation
            onRelocated?(
                adoptedLocation.cfi,
                adoptedLocation.percentage,
                adoptedLocation.spineHref,
                adoptedLocation.characterOffset,
                adoptedLocation.contextSnippet
            )

            let oldSlotDirection: PreparedSlotDirection = direction == .next ? .previous : .next
            preparedBaseCFIBySlot[oldCurrent] = adoptedLocation.cfi
            preparedDirectionBySlot[oldCurrent] = oldSlotDirection
        } else {
            currentLocation = nil
            enqueueOrDispatch(
                slotIndex: poolCurrent,
                js: "reportCurrentPosition(\(Self.jsStringLiteral("afterPageCurlTransition")))",
                family: .display
            )
        }

        syncAdjacentSlots(reason: "pageCurlTransition:\(direction.rawValue)")
    }

    private func handleRenderState(_ event: EPUBBridge.RenderStateEvent, for slotIndex: Int) {
        onRenderState?(slotIndex, event)
        guard slotIndex == poolCurrent,
              event.hasReadableText,
              event.loadToken == loadTokenBySlot[slotIndex]
        else {
            return
        }
        loadAdjacentSlotsIfNeeded(reason: "renderState:\(event.phase)")
    }

    private func handleFirstContentReady(_ event: EPUBBridge.FirstContentReadyEvent, for slotIndex: Int) {
        onFirstContentReady?(slotIndex, event)
        guard slotIndex == poolCurrent,
              event.loadToken == loadTokenBySlot[slotIndex]
        else {
            return
        }
        loadAdjacentSlotsIfNeeded(reason: "firstContentReady:\(event.phase)")
    }

    private func handleWebContentTerminated(for slotIndex: Int) {
        isHTMLReadyBySlot[slotIndex] = false
        queuedCommandsBySlot[slotIndex].removeAll()
        pendingLoadBySlot[slotIndex] = nil
        slotState[slotIndex] = .htmlLoading
        lastLocationBySlot[slotIndex] = nil
        preparedBaseCFIBySlot[slotIndex] = nil
        preparedDirectionBySlot[slotIndex] = nil
        pendingPrepareBaseCFIBySlot[slotIndex] = nil
        pendingPrepareDirectionBySlot[slotIndex] = nil

        guard slotIndex == poolCurrent || !isSingleSlotPagingEnabled else {
            return
        }

        guard let activeLoad else {
            return
        }

        queueLoadIfNeeded(slotIndex: slotIndex, load: activeLoad)
    }

    private func enqueueOrDispatch(slotIndex: Int, js: String, family: CommandFamily) {
        switch slotState[slotIndex] {
        case .bookReady(let token):
            dispatch(js: js, to: slotIndex, token: token, family: family)
        case .bookLoading(let token):
            queuedCommandsBySlot[slotIndex].append(PendingCommand(js: js, family: family, token: token))
        case .htmlLoading, .htmlLoaded:
            if family == .appearance {
                queuedCommandsBySlot[slotIndex].append(PendingCommand(js: js, family: family, token: 0))
                Log.shared.debug(
                    "PageCurl slot \(slotIndex) queued appearance command while \(slotState[slotIndex].label): \(Self.truncatedJSPrefix(js))"
                )
                return
            }
            let prefix = Self.truncatedJSPrefix(js)
            Log.shared.debug(
                "PageCurl slot \(slotIndex) dropped \(family.rawValue) command (no book loaded): \(prefix)"
            )
        case .failed:
            queuedCommandsBySlot[slotIndex].removeAll()
        }
    }

    private func flushQueuedCommands(for slotIndex: Int) {
        guard case .bookReady(let token) = slotState[slotIndex] else { return }
        let queued = queuedCommandsBySlot[slotIndex]
        queuedCommandsBySlot[slotIndex].removeAll()
        for command in queued where command.token == token || command.token == 0 {
            dispatch(js: command.js, to: slotIndex, token: token, family: command.family)
        }
    }

    private func dispatch(js: String, to slotIndex: Int, token: Int, family: CommandFamily) {
        pool[slotIndex].bridge.callJS(
            js,
            slotIndex: slotIndex,
            slotState: slotState[slotIndex].label,
            loadToken: token,
            commandFamily: family.rawValue
        )
    }

    private static func truncatedJSPrefix(_ js: String, limit: Int = 80) -> String {
        let singleLine = js.replacingOccurrences(of: "\n", with: " ")
        guard singleLine.count > limit else { return singleLine }
        return "\(singleLine.prefix(limit))…"
    }

    private static func jsStringLiteral(_ value: String) -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: [value]),
              let json = String(data: data, encoding: .utf8),
              json.count >= 2
        else {
            return "''"
        }
        return String(json.dropFirst().dropLast())
    }

    private func commandFamily(for js: String) -> CommandFamily {
        if js.hasPrefix("nextPage") || js.hasPrefix("prevPage") {
            return .navigation
        }
        if js.hasPrefix("set") {
            return .appearance
        }
        if js.hasPrefix("loadBook") {
            return .load
        }
        return .display
    }

    private func rotateForward() {
        guard !isSingleSlotPagingEnabled else {
            return
        }
        completePageCurlTransition(to: nextSlot, direction: .next)
    }

    private func rotateBackward() {
        guard !isSingleSlotPagingEnabled else {
            return
        }
        completePageCurlTransition(to: prevSlot, direction: .previous)
    }
}

private final class EPUBFileSchemeHandler: NSObject, WKURLSchemeHandler {
    static let shared = EPUBFileSchemeHandler()
    static let scheme = "epubreader-book"

    private var fileURLByToken: [String: URL] = [:]
    private let lock = NSLock()

    func register(fileURL: URL) -> URL {
        let token = UUID().uuidString
        lock.lock()
        fileURLByToken[token] = fileURL
        lock.unlock()
        Log.shared.debug("Registered EPUB custom-scheme token \(token) for \(fileURL.lastPathComponent)")
        return URL(string: "\(Self.scheme)://book/\(token).epub")!
    }

    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        guard let requestURL = urlSchemeTask.request.url,
              let token = requestURL.pathComponents.last?.replacingOccurrences(of: ".epub", with: "")
        else {
            Log.shared.error("EPUBFileSchemeHandler malformed request")
            fail(urlSchemeTask, code: 400, reason: "Malformed EPUB URL")
            return
        }

        Log.shared.debug("EPUBFileSchemeHandler start token=\(token)")

        lock.lock()
        let fileURL = fileURLByToken[token]
        lock.unlock()

        guard let fileURL else {
            Log.shared.error("EPUBFileSchemeHandler unknown token=\(token)")
            fail(urlSchemeTask, code: 404, reason: "Unknown EPUB token")
            return
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let response = URLResponse(
                url: requestURL,
                mimeType: "application/epub+zip",
                expectedContentLength: data.count,
                textEncodingName: nil
            )
            urlSchemeTask.didReceive(response)
            urlSchemeTask.didReceive(data)
            urlSchemeTask.didFinish()
            Log.shared.debug("EPUBFileSchemeHandler finished token=\(token) bytes=\(data.count)")
        } catch {
            Log.shared.error("EPUBFileSchemeHandler failed token=\(token): \(error.localizedDescription)")
            fail(urlSchemeTask, code: 500, reason: "Unable to read EPUB data")
        }
    }

    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        Log.shared.debug("EPUBFileSchemeHandler stopped request \(urlSchemeTask.request.url?.absoluteString ?? "unknown")")
    }

    private func fail(_ task: WKURLSchemeTask, code: Int, reason: String) {
        let error = NSError(
            domain: "EPUBFileSchemeHandler",
            code: code,
            userInfo: [NSLocalizedDescriptionKey: reason]
        )
        task.didFailWithError(error)
    }
}

// MARK: - UIPageViewControllerDataSource

extension PageCurlViewController: UIPageViewControllerDataSource {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard !isSingleSlotPagingEnabled else { return nil }
        let requestedSlot = (viewController as? EPUBPageContentViewController)?.slotIndex ?? -1
        let prepared = viewController === currentSlot && isSlotPrepared(prevSlot.slotIndex, for: .previous)
        Log.shared.debug(
            """
            PageCurl dataSource before requested=\(requestedSlot) current=\(poolCurrent) \
            prev=\(prevSlot.slotIndex) prepared=\(prepared) state=\(slotState[prevSlot.slotIndex].label)
            """
        )
        guard prepared else {
            return nil
        }
        detachFromPrewarmIfNeeded(prevSlot.slotIndex)
        return prevSlot
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard !isSingleSlotPagingEnabled else { return nil }
        let requestedSlot = (viewController as? EPUBPageContentViewController)?.slotIndex ?? -1
        let prepared = viewController === currentSlot && isSlotPrepared(nextSlot.slotIndex, for: .next)
        Log.shared.debug(
            """
            PageCurl dataSource after requested=\(requestedSlot) current=\(poolCurrent) \
            next=\(nextSlot.slotIndex) prepared=\(prepared) state=\(slotState[nextSlot.slotIndex].label)
            """
        )
        guard prepared else {
            return nil
        }
        detachFromPrewarmIfNeeded(nextSlot.slotIndex)
        return nextSlot
    }
}

// MARK: - UIPageViewControllerDelegate

extension PageCurlViewController: UIPageViewControllerDelegate {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard !isSingleSlotPagingEnabled else { return }
        guard !isProgrammaticTurnInFlight else { return }
        guard completed, let appearing = pageViewController.viewControllers?.first else {
            syncAdjacentSlots(reason: "pageCurlCancelled")
            return
        }
        if appearing === nextSlot {
            rotateForward()
        } else if appearing === prevSlot {
            rotateBackward()
        }
    }
}

// MARK: - PageCurlReaderView

/// `UIViewControllerRepresentable` that embeds ``PageCurlViewController``
/// into SwiftUI and wires bridge callbacks to a ``ReaderViewModel``.
struct PageCurlReaderView: UIViewControllerRepresentable {

    let viewModel: ReaderViewModel
    let onCreated: (PageCurlViewController) -> Void

    func makeUIViewController(context: Context) -> PageCurlViewController {
        let vc = PageCurlViewController()
        context.coordinator.wire(vc, to: viewModel)
        DispatchQueue.main.async {
            onCreated(vc)
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: PageCurlViewController, context: Context) {}

    static func dismantleUIViewController(_ uiViewController: PageCurlViewController, coordinator: Coordinator) {
        uiViewController.invalidatePool()
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    @MainActor
    final class Coordinator {
        func wire(_ vc: PageCurlViewController, to viewModel: ReaderViewModel) {
            vc.onRelocated = { [weak viewModel] cfi, pct, spineHref, characterOffset, contextSnippet in
                viewModel?.handleRelocated(
                    cfi: cfi,
                    pct: pct,
                    spineHref: spineHref,
                    characterOffset: characterOffset,
                    contextSnippet: contextSnippet,
                    atEnd: false
                )
            }
            vc.onBookReady = { [weak viewModel, weak vc] in
                Log.shared.info("EPUB book ready (PageCurl pool)")
                viewModel?.handleBookReady(in: vc)
            }
            vc.onBookError = { msg in
                Log.shared.error("EPUB book load failed: \(msg)")
            }
            vc.onAtChapterEnd = { [weak viewModel] in
                guard let viewModel else { return }
                viewModel.handleRelocated(
                    cfi: viewModel.currentCFI,
                    pct: viewModel.percentage,
                    spineHref: "",
                    characterOffset: 0,
                    contextSnippet: "",
                    atEnd: true
                )
            }
            vc.onJavaScriptExecutionFailed = { [weak viewModel] failure in
                viewModel?.handleJavaScriptExecutionFailure(failure)
            }
            vc.onJSGuardBlocked = { [weak viewModel] _, event in
                viewModel?.handleJSGuardBlocked(event)
            }
            vc.onLocationsSnapshot = { [weak viewModel] total, serialized in
                viewModel?.handleLocationsSnapshot(totalLocations: total, serializedLocations: serialized)
            }
            vc.onWordCountSample = { [weak viewModel] counts in
                viewModel?.handleWordCountSample(counts)
            }
            vc.onChapterWordCount = { [weak viewModel] index, count in
                viewModel?.handleChapterWordCount(index: index, count: count)
            }
            vc.onRenderState = { [weak viewModel] slotIndex, event in
                viewModel?.handleRenderState(slotIndex: slotIndex, event: event)
            }
            vc.onFirstContentReady = { [weak viewModel] slotIndex, event in
                viewModel?.handleFirstContentReady(slotIndex: slotIndex, event: event)
            }
        }
    }
}
