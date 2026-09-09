import UIKit
import WebKit
import SwiftUI

// MARK: - EPUBPageContentViewController

/// One WKWebView-backed rendition slot in the native page-curl pool.
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
        loadReaderHTML()
    }

    func reloadReaderHTML() {
        hasMarkedReady = false
        loadReaderHTML()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard !hasMarkedReady, webView.url?.lastPathComponent == "reader.html" else { return }
        hasMarkedReady = true
        onReaderHTMLReady?(slotIndex)
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        Log.shared.error("WKWebView web content process terminated for page-curl slot \(slotIndex)")
        onWebContentTerminated?(slotIndex)
        reloadReaderHTML()
    }

    private func loadReaderHTML() {
        guard let htmlURL = Bundle.main.url(forResource: "reader", withExtension: "html") else {
            Log.shared.error("reader.html missing from app bundle")
            return
        }
        webView.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL.deletingLastPathComponent())
    }
}

// MARK: - PageCurlViewController

/// Native page-curl reader backed by exactly three synchronized WKWebView slots.
@MainActor
final class PageCurlViewController: UIPageViewController {

    enum ReaderTurnDirection: String {
        case forward
        case backward

        var pageDirection: UIPageViewController.NavigationDirection {
            switch self {
            case .forward: return .forward
            case .backward: return .reverse
            }
        }

        var adjacentDelta: Int {
            switch self {
            case .forward: return 1
            case .backward: return -1
            }
        }
    }

    private enum SlotLifecycleState: Equatable {
        case htmlLoading
        case htmlReady
        case bookLoading(token: Int)
        case bookReady(token: Int)
        case syncPending(token: Int, syncId: String)
        case synced(token: Int, syncKey: String)
        case failed(token: Int, error: String)

        var label: String {
            switch self {
            case .htmlLoading: return "htmlLoading"
            case .htmlReady: return "htmlReady"
            case .bookLoading: return "bookLoading"
            case .bookReady: return "bookReady"
            case .syncPending: return "syncPending"
            case .synced: return "synced"
            case .failed: return "failed"
            }
        }

        var token: Int? {
            switch self {
            case .bookLoading(let token),
                 .bookReady(let token),
                 .syncPending(let token, _),
                 .synced(let token, _),
                 .failed(let token, _):
                return token
            case .htmlLoading, .htmlReady:
                return nil
            }
        }

        var canDispatch: Bool {
            switch self {
            case .bookReady, .syncPending, .synced:
                return true
            case .htmlLoading, .htmlReady, .bookLoading, .failed:
                return false
            }
        }
    }

    private enum CommandFamily: String {
        case navigation
        case appearance
        case load
        case display
    }

    private struct PendingCommand {
        let js: String
        let family: CommandFamily
        let token: Int
    }

    private struct PendingLoad {
        let bookURLString: String
        let fallbackEscapedBase64: String?
        let locationsCache: String?
    }

    private struct RelocationSnapshot {
        let cfi: String
        let percentage: Double
        let spineHref: String
        let characterOffset: Int64
        let contextSnippet: String
    }

    private struct PendingSync {
        let slotIndex: Int
        let syncKey: String
        let token: Int
        let delta: Int
    }

    private let pool: [EPUBPageContentViewController]
    private var poolCurrent = 1
    private var slotState = [SlotLifecycleState](repeating: .htmlLoading, count: 3)
    private var isHTMLReadyBySlot = [Bool](repeating: false, count: 3)
    private var loadTokenBySlot = [Int](repeating: 0, count: 3)
    private var adjacentRetryCountBySlot = [Int](repeating: 0, count: 3)
    private var queuedCommandsBySlot = [[PendingCommand]](repeating: [], count: 3)
    private var relocationBySlot = [RelocationSnapshot?](repeating: nil, count: 3)
    private var pendingLoadBySlot = [PendingLoad?](repeating: nil, count: 3)
    private var pendingSyncById: [String: PendingSync] = [:]
    private var currentBookLoad: PendingLoad?
    private var backgroundLoadQueue: [Int] = []
    private var hasStartedInitialAdjacentLoads = false
    private var isCurrentDisplayPending = false
    private var latestAppearance: ReaderAppearance?
    private var canonicalCFI = ""
    private var queuedTurnDirection: ReaderTurnDirection?
    private var isPageTransitionInProgress = false
    private var isProgrammaticTurnInProgress = false
    private var suppressTurnsUntil: Date?

    var currentSlot: EPUBPageContentViewController { pool[poolCurrent] }
    var prevSlot: EPUBPageContentViewController { pool[(poolCurrent + 2) % 3] }
    var nextSlot: EPUBPageContentViewController { pool[(poolCurrent + 1) % 3] }

    var onRelocated: ((String, Double, String, Int64, String) -> Void)?
    var onBookReady: (() -> Void)?
    var onBookError: ((String) -> Void)?
    var onSelected: ((ReaderTextSelection) -> Void)?
    var onMarkClicked: ((String) -> Void)?
    var onRequestHighlights: ((String, Int) -> Void)?
    var onFootnoteRequest: ((String, String) -> Void)?
    var onCenterTap: (() -> Void)?
    var onAtChapterEnd: (() -> Void)?
    var onLocationsSnapshot: ((Int, String?) -> Void)?
    var onWordCountSample: (([Int]) -> Void)?
    var onChapterWordCount: ((Int, Int) -> Void)?
    var onJavaScriptExecutionFailed: ((EPUBBridge.JavaScriptExecutionFailure) -> Void)?
    var onJSGuardBlocked: ((Int, EPUBBridge.JSGuardBlockedEvent) -> Void)?

    init() {
        pool = (0..<3).map { EPUBPageContentViewController(slotIndex: $0) }
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        pool.forEach { slot in
            slot.onReaderHTMLReady = { [weak self] index in
                self?.markSlotHTMLReady(index)
            }
            slot.onWebContentTerminated = { [weak self] index in
                self?.recoverTerminatedSlot(index)
            }
        }
        pool.forEach { $0.loadViewIfNeeded() }
        setViewControllers([currentSlot], direction: .forward, animated: false)
        wireAllBridgeCallbacks()
        installTapZoneRecognizer()
        restrictNativeCurlGestures()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizeLoadedSlots()
    }

    func loadBook(
        fileURL: URL,
        fallbackEscapedBase64: String? = nil,
        locationsCache: String? = nil
    ) {
        let bridgedURLString = EPUBFileSchemeHandler.shared.register(fileURL: fileURL).absoluteString
        let pendingLoad = PendingLoad(
            bookURLString: bridgedURLString,
            fallbackEscapedBase64: fallbackEscapedBase64,
            locationsCache: locationsCache
        )
        currentBookLoad = pendingLoad
        canonicalCFI = ""
        queuedTurnDirection = nil
        hasStartedInitialAdjacentLoads = false
        isCurrentDisplayPending = false
        pendingSyncById.removeAll()
        backgroundLoadQueue.removeAll()
        adjacentRetryCountBySlot = [Int](repeating: 0, count: 3)
        relocationBySlot = [RelocationSnapshot?](repeating: nil, count: 3)
        for slotIndex in pool.indices where slotIndex != poolCurrent {
            queuedCommandsBySlot[slotIndex].removeAll()
            pendingLoadBySlot[slotIndex] = nil
            relocationBySlot[slotIndex] = nil
            if isHTMLReadyBySlot[slotIndex] {
                slotState[slotIndex] = .htmlReady
            } else {
                slotState[slotIndex] = .htmlLoading
            }
        }
        backgroundLoadQueue = [nextSlot.slotIndex, prevSlot.slotIndex]
        queueLoad(pendingLoad, slotIndex: poolCurrent)
    }

    func displayCFI(_ cfi: String) {
        displayLocation(cfi)
    }

    func displayLocation(_ target: String) {
        let escaped = Self.javaScriptStringLiteral(target)
        if !hasStartedInitialAdjacentLoads {
            isCurrentDisplayPending = true
        }
        enqueueOrDispatch(slotIndex: poolCurrent, js: "displayLocation('\(escaped)')", family: .display)
    }

    func displayLocation(_ percentage: Double) {
        if !hasStartedInitialAdjacentLoads {
            isCurrentDisplayPending = true
        }
        enqueueOrDispatch(slotIndex: poolCurrent, js: "displayLocation(\(percentage))", family: .display)
    }

    func requestLocationsSnapshot() {
        enqueueOrDispatch(slotIndex: poolCurrent, js: "snapshotLocations()", family: .display)
    }

    func requestChapterWordCount(index: Int) {
        enqueueOrDispatch(slotIndex: poolCurrent, js: "requestChapterWordCount(\(index))", family: .display)
    }

    func callJS(_ js: String) {
        if js == "nextPage()" || js.hasPrefix("nextPage(") {
            turnPage(.forward)
            return
        }
        if js == "prevPage()" || js.hasPrefix("prevPage(") {
            turnPage(.backward)
            return
        }
        enqueueOrDispatch(
            slotIndex: poolCurrent,
            js: rewriteLegacyDisplayCall(js),
            family: commandFamily(for: js)
        )
    }

    func turnPage(_ direction: ReaderTurnDirection) {
        startNativeTurn(direction: direction, animated: true, queueIfNeeded: true)
    }

    func applyHighlights(_ json: String, to slotIndex: Int) {
        let escapedJSON = Self.javaScriptStringLiteral(json)
        enqueueOrDispatch(
            slotIndex: slotIndex,
            js: "applyHighlights('\(escapedJSON)')",
            family: .display
        )
    }

    func noteTextSelectionInteraction() {
        suppressTurnsUntil = Date().addingTimeInterval(0.75)
    }

    func applyAppearance(_ appearance: ReaderAppearance) {
        latestAppearance = appearance
        let theme = Self.javaScriptStringLiteral(appearance.theme)
        let family = Self.javaScriptStringLiteral(appearance.fontFamily)
        let margin = Self.marginPixels(for: appearance.marginStyle)
        let js = """
        applyAppearance({theme:'\(theme)',fontFamily:'\(family)',fontSize:\(Int(appearance.fontSize)),lineSpacing:\(appearance.lineSpacing),margin:\(margin),justify:\(appearance.textAlignment == "justify"),hyphenation:\(appearance.hyphenation)})
        """
        broadcast(js: js, family: .appearance)
    }

    func applyTheme(_ theme: String) {
        let escaped = Self.javaScriptStringLiteral(theme)
        broadcast(js: "setTheme('\(escaped)')", family: .appearance)
    }

    func applyFontSize(_ px: Int) {
        broadcast(js: "setFontSize(\(px))", family: .appearance)
    }

    func applyFontFamily(_ family: String) {
        let escaped = Self.javaScriptStringLiteral(family)
        broadcast(js: "setFontFamily('\(escaped)')", family: .appearance)
    }

    func applyLineSpacing(_ value: Double) {
        broadcast(js: "setLineSpacing(\(value))", family: .appearance)
    }

    func applyMargin(_ px: Int) {
        broadcast(js: "setMargin(\(px))", family: .appearance)
    }

    func applyJustify(_ justify: Bool) {
        broadcast(js: "setJustify(\(justify))", family: .appearance)
    }

    func applyHyphenation(_ on: Bool) {
        broadcast(js: "setHyphenation(\(on))", family: .appearance)
    }

    static func marginPixels(for style: String) -> Int {
        switch style {
        case "narrow": return 8
        case "wide": return 40
        default: return 24
        }
    }

    func invalidatePool() {
        dataSource = nil
        delegate = nil
        pool.forEach { $0.bridge.invalidate() }
    }

    private func installTapZoneRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapZone(_:)))
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)
    }

    private func restrictNativeCurlGestures() {
        for recognizer in gestureRecognizers {
            if recognizer is UITapGestureRecognizer {
                recognizer.isEnabled = false
            }
        }
    }

    @objc private func handleTapZone(_ recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .ended, view.bounds.width > 0 else {
            return
        }
        let location = recognizer.location(in: view)
        let xRatio = location.x / view.bounds.width
        if xRatio < 0.25 {
            turnPage(.backward)
        } else if xRatio > 0.75 {
            turnPage(.forward)
        } else {
            onCenterTap?()
        }
    }

    private func wireAllBridgeCallbacks() {
        for slot in pool {
            wireBridgeCallbacks(for: slot)
        }
    }

    private func wireBridgeCallbacks(for slot: EPUBPageContentViewController) {
        slot.bridge.onRelocated = { [weak self, weak slot] cfi, pct, spineHref, offset, snippet in
            guard let self, let slot else { return }
            self.handleRelocated(
                slotIndex: slot.slotIndex,
                cfi: cfi,
                percentage: pct,
                spineHref: spineHref,
                characterOffset: offset,
                contextSnippet: snippet
            )
        }
        slot.bridge.onBookReady = { [weak self, weak slot] in
            guard let self, let slot else { return }
            self.handleBookReady(for: slot.slotIndex)
        }
        slot.bridge.onBookError = { [weak self, weak slot] message in
            guard let self, let slot else { return }
            self.handleBookError(for: slot.slotIndex, message: message)
        }
        slot.bridge.onSelected = { [weak self, weak slot] selection in
            guard let self, let slot, slot.slotIndex == self.poolCurrent else { return }
            self.noteTextSelectionInteraction()
            let convertedRect = slot.webView.convert(selection.rect, to: self.view)
            self.onSelected?(selection.moving(to: convertedRect))
        }
        slot.bridge.onMarkClicked = { [weak self, weak slot] id in
            guard let self, let slot, slot.slotIndex == self.poolCurrent else { return }
            self.onMarkClicked?(id)
        }
        slot.bridge.onRequestHighlights = { [weak self, weak slot] href in
            guard let self, let slot else { return }
            self.onRequestHighlights?(href, slot.slotIndex)
        }
        slot.bridge.onFootnoteRequest = { [weak self, weak slot] href, text in
            guard let self, let slot, slot.slotIndex == self.poolCurrent else { return }
            self.onFootnoteRequest?(href, text)
        }
        slot.bridge.onAtChapterEnd = { [weak self, weak slot] in
            guard let self, let slot, slot.slotIndex == self.poolCurrent else { return }
            self.onAtChapterEnd?()
        }
        slot.bridge.onLocationsSnapshot = { [weak self, weak slot] totalLocations, serializedLocations in
            guard let self, let slot, slot.slotIndex == self.poolCurrent else { return }
            self.onLocationsSnapshot?(totalLocations, serializedLocations)
        }
        slot.bridge.onWordCountSample = { [weak self, weak slot] counts in
            guard let self, let slot, slot.slotIndex == self.poolCurrent else { return }
            self.onWordCountSample?(counts)
        }
        slot.bridge.onChapterWordCount = { [weak self, weak slot] index, count in
            guard let self, let slot, slot.slotIndex == self.poolCurrent else { return }
            self.onChapterWordCount?(index, count)
        }
        slot.bridge.onSyncComplete = { [weak self] event in
            self?.handleSyncComplete(event)
        }
        slot.bridge.onJavaScriptExecutionFailed = { [weak self] failure in
            self?.onJavaScriptExecutionFailed?(failure)
        }
        slot.bridge.onJSGuardBlocked = { [weak self, weak slot] event in
            guard let self, let slot else { return }
            self.onJSGuardBlocked?(slot.slotIndex, event)
        }
    }

    private func handleRelocated(
        slotIndex: Int,
        cfi: String,
        percentage: Double,
        spineHref: String,
        characterOffset: Int64,
        contextSnippet: String
    ) {
        guard !cfi.isEmpty, relocationBySlot.indices.contains(slotIndex) else {
            return
        }
        relocationBySlot[slotIndex] = RelocationSnapshot(
            cfi: cfi,
            percentage: percentage,
            spineHref: spineHref,
            characterOffset: characterOffset,
            contextSnippet: contextSnippet
        )
        guard slotIndex == poolCurrent else {
            return
        }
        canonicalCFI = cfi
        isCurrentDisplayPending = false
        onRelocated?(cfi, percentage, spineHref, characterOffset, contextSnippet)
        if !hasStartedInitialAdjacentLoads && slotState[poolCurrent].canDispatch {
            hasStartedInitialAdjacentLoads = true
            startNextBackgroundLoadIfNeeded()
        } else if !isPageTransitionInProgress && !isProgrammaticTurnInProgress {
            syncAdjacentSlots(from: cfi)
        }
    }

    private func markSlotHTMLReady(_ slotIndex: Int) {
        isHTMLReadyBySlot[slotIndex] = true
        if case .htmlLoading = slotState[slotIndex] {
            slotState[slotIndex] = .htmlReady
        }
        Log.shared.debug("PageCurl slot \(slotIndex) HTML ready")
        flushPendingLoad(for: slotIndex)
    }

    private func queueLoad(_ pendingLoad: PendingLoad, slotIndex: Int) {
        loadTokenBySlot[slotIndex] += 1
        let token = loadTokenBySlot[slotIndex]
        queuedCommandsBySlot[slotIndex].removeAll()
        pendingLoadBySlot[slotIndex] = pendingLoad
        slotState[slotIndex] = .bookLoading(token: token)
        Log.shared.debug("PageCurl slot \(slotIndex) state=bookLoading token=\(token)")
        flushPendingLoad(for: slotIndex)
    }

    private func flushPendingLoad(for slotIndex: Int) {
        guard isHTMLReadyBySlot[slotIndex],
              case .bookLoading(let token) = slotState[slotIndex],
              let pendingLoad = pendingLoadBySlot[slotIndex]
        else { return }

        pendingLoadBySlot[slotIndex] = nil
        let size = renditionSize()
        let width = size.width
        let height = size.height
        let fallback = pendingLoad.fallbackEscapedBase64.map { "'\($0)'" } ?? "null"
        let cache = pendingLoad.locationsCache.map { "'\(Self.javaScriptStringLiteral($0))'" } ?? "null"
        let js = "loadBook('\(pendingLoad.bookURLString)', \(fallback), \(width), \(height), \(cache))"
        dispatch(js: js, to: slotIndex, token: token, family: .load)
    }

    private func handleBookReady(for slotIndex: Int) {
        guard case .bookLoading(let token) = slotState[slotIndex],
              token == loadTokenBySlot[slotIndex]
        else { return }

        slotState[slotIndex] = .bookReady(token: token)
        Log.shared.debug("PageCurl slot \(slotIndex) state=bookReady token=\(token)")
        if let latestAppearance {
            applyAppearance(latestAppearance)
        }
        flushQueuedCommands(for: slotIndex)
        if slotIndex == poolCurrent {
            onBookReady?()
            if !hasStartedInitialAdjacentLoads,
               !isCurrentDisplayPending,
               !canonicalCFI.isEmpty {
                hasStartedInitialAdjacentLoads = true
                startNextBackgroundLoadIfNeeded()
            }
        } else if !canonicalCFI.isEmpty {
            Log.shared.debug("PageCurl adjacentBookReady slot=\(slotIndex) token=\(token)")
            let delta = slotIndex == prevSlot.slotIndex ? -1 : 1
            sync(slotIndex: slotIndex, to: canonicalCFI, delta: delta)
        } else {
            startNextBackgroundLoadIfNeeded()
        }
    }

    private func handleBookError(for slotIndex: Int, message: String) {
        let token = loadTokenBySlot[slotIndex]
        slotState[slotIndex] = .failed(token: token, error: message)
        queuedCommandsBySlot[slotIndex].removeAll()
        Log.shared.error("PageCurl slot \(slotIndex) failed: \(message)")
        if slotIndex == poolCurrent {
            onBookError?(message)
        } else {
            if retryAdjacentSlot(slotIndex, reason: "load failed: \(message)") {
                return
            }
            startNextBackgroundLoadIfNeeded()
        }
    }

    private func recoverTerminatedSlot(_ slotIndex: Int) {
        isHTMLReadyBySlot[slotIndex] = false
        slotState[slotIndex] = .htmlLoading
        relocationBySlot[slotIndex] = nil
        pendingSyncById = pendingSyncById.filter { $0.value.slotIndex != slotIndex }
        guard let currentBookLoad else { return }
        queueLoad(currentBookLoad, slotIndex: slotIndex)
        if slotIndex == poolCurrent, !canonicalCFI.isEmpty {
            displayLocation(canonicalCFI)
        }
    }

    private func startNextBackgroundLoadIfNeeded() {
        guard let currentBookLoad,
              !backgroundLoadQueue.isEmpty,
              !hasBackgroundLoadInProgress()
        else { return }

        let slotIndex = backgroundLoadQueue.removeFirst()
        guard slotIndex != poolCurrent else {
            startNextBackgroundLoadIfNeeded()
            return
        }

        Log.shared.debug(
            """
            PageCurl adjacentLoadStarted slot=\(slotIndex) \
            hasFallbackBase64=\(currentBookLoad.fallbackEscapedBase64 != nil)
            """
        )
        let backgroundLoad = currentBookLoad
        queueLoad(backgroundLoad, slotIndex: slotIndex)
    }

    private func hasBackgroundLoadInProgress() -> Bool {
        pool.indices.contains { slotIndex in
            guard slotIndex != poolCurrent else {
                return false
            }
            if case .bookLoading = slotState[slotIndex] {
                return true
            }
            return false
        }
    }

    private func enqueueOrDispatch(slotIndex: Int, js: String, family: CommandFamily) {
        guard slotState.indices.contains(slotIndex) else { return }
        let state = slotState[slotIndex]
        if state.canDispatch, let token = state.token {
            dispatch(js: js, to: slotIndex, token: token, family: family)
        } else if case .bookLoading(let token) = state {
            queuedCommandsBySlot[slotIndex].append(PendingCommand(js: js, family: family, token: token))
        } else {
            Log.shared.debug("PageCurl slot \(slotIndex) ignored \(family.rawValue) command while state=\(state.label)")
        }
    }

    private func flushQueuedCommands(for slotIndex: Int) {
        guard let token = slotState[slotIndex].token else { return }
        let queued = queuedCommandsBySlot[slotIndex]
        queuedCommandsBySlot[slotIndex].removeAll()
        for command in queued where command.token == token {
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

    private func broadcast(js: String, family: CommandFamily) {
        for slotIndex in pool.indices {
            enqueueOrDispatch(slotIndex: slotIndex, js: js, family: family)
        }
    }

    private func syncAdjacentSlots(from cfi: String) {
        guard !cfi.isEmpty else { return }
        sync(slotIndex: nextSlot.slotIndex, to: cfi, delta: 1)
        sync(slotIndex: prevSlot.slotIndex, to: cfi, delta: -1)
    }

    private func sync(slotIndex: Int, to cfi: String, delta: Int) {
        guard let token = slotState[slotIndex].token, slotState[slotIndex].canDispatch else {
            return
        }
        let syncKey = Self.syncKey(cfi: cfi, delta: delta)
        if case .synced(_, let existingKey) = slotState[slotIndex], existingKey == syncKey {
            return
        }
        let syncId = UUID().uuidString
        pendingSyncById[syncId] = PendingSync(
            slotIndex: slotIndex,
            syncKey: syncKey,
            token: token,
            delta: delta
        )
        slotState[slotIndex] = .syncPending(token: token, syncId: syncId)
        Log.shared.debug("PageCurl adjacentSyncStarted slot=\(slotIndex) delta=\(delta) syncId=\(syncId)")
        let escapedCFI = Self.javaScriptStringLiteral(cfi)
        let js = "displayAdjacent('\(escapedCFI)', \(delta), '\(syncId)')"
        dispatch(js: js, to: slotIndex, token: token, family: .display)
    }

    private func handleSyncComplete(_ event: EPUBBridge.SyncCompleteEvent) {
        guard let pendingSync = pendingSyncById.removeValue(forKey: event.syncId),
              slotState.indices.contains(pendingSync.slotIndex),
              loadTokenBySlot[pendingSync.slotIndex] == pendingSync.token,
              case .syncPending(_, let activeSyncId) = slotState[pendingSync.slotIndex],
              activeSyncId == event.syncId
        else { return }

        if let error = event.error, !error.isEmpty {
            slotState[pendingSync.slotIndex] = .bookReady(token: pendingSync.token)
            Log.shared.error(
                """
                PageCurl adjacentSyncFailed slot=\(pendingSync.slotIndex) \
                delta=\(pendingSync.delta) error=\(error)
                """
            )
            if retryAdjacentSlot(pendingSync.slotIndex, reason: "sync failed: \(error)") {
                return
            }
            clearQueuedTurnIfTargetIs(pendingSync.slotIndex)
            startNextBackgroundLoadIfNeeded()
            return
        }

        if !event.cfi.isEmpty {
            relocationBySlot[pendingSync.slotIndex] = RelocationSnapshot(
                cfi: event.cfi,
                percentage: event.percentage,
                spineHref: event.spineHref,
                characterOffset: 0,
                contextSnippet: ""
            )
        }
        slotState[pendingSync.slotIndex] = .synced(
            token: pendingSync.token,
            syncKey: pendingSync.syncKey
        )
        Log.shared.debug("PageCurl adjacentSyncCompleted slot=\(pendingSync.slotIndex) delta=\(pendingSync.delta)")
        adjacentRetryCountBySlot[pendingSync.slotIndex] = 0
        attemptQueuedTurnIfPossible()
        startNextBackgroundLoadIfNeeded()
    }

    private func startNativeTurn(
        direction: ReaderTurnDirection,
        animated: Bool,
        queueIfNeeded: Bool = false
    ) {
        guard canStartPageTurn(direction: direction) else {
            if queueIfNeeded {
                queueTurnIfSyncing(direction)
            }
            return
        }
        let target = targetSlot(for: direction)
        isProgrammaticTurnInProgress = true
        isPageTransitionInProgress = true
        Log.shared.debug("PageCurl nativeCurlStarted direction=\(direction.rawValue)")
        setViewControllers([target], direction: direction.pageDirection, animated: animated) { [weak self, weak target] completed in
            guard let self, let target else { return }
            self.isProgrammaticTurnInProgress = false
            self.isPageTransitionInProgress = false
            guard completed else { return }
            self.completeNativeTurn(to: target)
            Log.shared.debug("PageCurl nativeCurlCompleted direction=\(direction.rawValue)")
        }
    }

    private func completeNativeTurn(to target: EPUBPageContentViewController) {
        if target === nextSlot {
            poolCurrent = (poolCurrent + 1) % 3
        } else if target === prevSlot {
            poolCurrent = (poolCurrent + 2) % 3
        } else {
            return
        }
        publishCurrentSlotRelocation()
        syncAdjacentSlots(from: canonicalCFI)
    }

    private func publishCurrentSlotRelocation() {
        guard let relocation = relocationBySlot[poolCurrent], !relocation.cfi.isEmpty else {
            return
        }
        canonicalCFI = relocation.cfi
        onRelocated?(
            relocation.cfi,
            relocation.percentage,
            relocation.spineHref,
            relocation.characterOffset,
            relocation.contextSnippet
        )
    }

    private func canStartPageTurn(direction: ReaderTurnDirection) -> Bool {
        if let suppressTurnsUntil, suppressTurnsUntil > Date() {
            return false
        }
        guard !isPageTransitionInProgress, !isProgrammaticTurnInProgress else {
            return false
        }
        guard slotState[poolCurrent].canDispatch, !canonicalCFI.isEmpty else {
            return false
        }
        let targetIndex = targetSlot(for: direction).slotIndex
        let expectedKey = Self.syncKey(cfi: canonicalCFI, delta: direction.adjacentDelta)
        guard case .synced(_, let syncKey) = slotState[targetIndex], syncKey == expectedKey else {
            Log.shared.debug(
                """
                PageCurl turnBlocked direction=\(direction.rawValue) \
                slot=\(targetIndex) state=\(slotState[targetIndex].label)
                """
            )
            return false
        }
        return true
    }

    private func queueTurnIfSyncing(_ direction: ReaderTurnDirection) {
        guard slotState[poolCurrent].canDispatch,
              !canonicalCFI.isEmpty,
              !isPageTransitionInProgress,
              !isProgrammaticTurnInProgress
        else { return }

        let targetIndex = targetSlot(for: direction).slotIndex
        switch slotState[targetIndex] {
        case .bookLoading, .bookReady, .syncPending:
            queuedTurnDirection = direction
            Log.shared.debug(
                """
                PageCurl turnQueuedWhileSyncing direction=\(direction.rawValue) \
                slot=\(targetIndex) state=\(slotState[targetIndex].label)
                """
            )
        case .htmlLoading, .htmlReady, .synced, .failed:
            break
        }
    }

    private func attemptQueuedTurnIfPossible() {
        guard let direction = queuedTurnDirection,
              canStartPageTurn(direction: direction)
        else { return }
        queuedTurnDirection = nil
        startNativeTurn(direction: direction, animated: true)
    }

    private func clearQueuedTurnIfTargetIs(_ slotIndex: Int) {
        guard let queuedTurnDirection,
              targetSlot(for: queuedTurnDirection).slotIndex == slotIndex
        else { return }
        self.queuedTurnDirection = nil
    }

    private func targetSlot(for direction: ReaderTurnDirection) -> EPUBPageContentViewController {
        switch direction {
        case .forward: return nextSlot
        case .backward: return prevSlot
        }
    }

    private func resizeLoadedSlots() {
        let size = renditionSize()
        let width = size.width
        let height = size.height
        guard width > 0, height > 0 else { return }
        for slotIndex in pool.indices where slotState[slotIndex].canDispatch {
            enqueueOrDispatch(
                slotIndex: slotIndex,
                js: "resizeRendition(\(width), \(height))",
                family: .display
            )
        }
        if !canonicalCFI.isEmpty {
            syncAdjacentSlots(from: canonicalCFI)
        }
    }

    private func renditionSize() -> (width: Int, height: Int) {
        let insets = view.safeAreaInsets
        let width = max(Int(view.bounds.width), 0)
        let height = max(Int(view.bounds.height - insets.top - insets.bottom), 0)
        return (width, height)
    }

    private func retryAdjacentSlot(_ slotIndex: Int, reason: String) -> Bool {
        guard slotIndex != poolCurrent,
              slotState.indices.contains(slotIndex),
              let currentBookLoad,
              adjacentRetryCountBySlot[slotIndex] == 0
        else {
            Log.shared.error("PageCurl adjacentSyncFailed slot=\(slotIndex) retryExhausted reason=\(reason)")
            return false
        }

        adjacentRetryCountBySlot[slotIndex] += 1
        queuedCommandsBySlot[slotIndex].removeAll()
        pendingLoadBySlot[slotIndex] = nil
        relocationBySlot[slotIndex] = nil
        pendingSyncById = pendingSyncById.filter { $0.value.slotIndex != slotIndex }
        Log.shared.error(
            """
            PageCurl adjacentSyncFailed slot=\(slotIndex) retryingFromBase64 \
            reason=\(reason) hasFallbackBase64=\(currentBookLoad.fallbackEscapedBase64 != nil)
            """
        )
        queueLoad(currentBookLoad, slotIndex: slotIndex)
        return true
    }

    private func directionForNativePan(_ recognizer: UIPanGestureRecognizer) -> ReaderTurnDirection? {
        guard !isPageTransitionInProgress, !isProgrammaticTurnInProgress else { return nil }
        if let suppressTurnsUntil, suppressTurnsUntil > Date() {
            return nil
        }
        let bounds = view.bounds
        guard bounds.width > 0, bounds.height > 0 else { return nil }
        let location = recognizer.location(in: view)
        let velocity = recognizer.velocity(in: view)
        let translation = recognizer.translation(in: view)
        let velocityIsHorizontal = abs(velocity.x) > max(abs(velocity.y) * 1.2, 60)
        let translationIsHorizontal = abs(translation.x) > max(abs(translation.y) * 1.2, 8)
        guard velocityIsHorizontal || translationIsHorizontal else {
            return nil
        }
        let horizontalIntent = velocityIsHorizontal ? velocity.x : translation.x
        let edgeWidth = min(max(bounds.width * 0.18, 44), 96)
        if location.x >= bounds.maxX - edgeWidth, horizontalIntent < 0 {
            return .forward
        }
        if location.x <= bounds.minX + edgeWidth, horizontalIntent > 0 {
            return .backward
        }
        return nil
    }

    private func rewriteLegacyDisplayCall(_ js: String) -> String {
        guard js.hasPrefix("displayCFI(") else {
            return js
        }
        return "displayLocation(" + js.dropFirst("displayCFI(".count)
    }

    private func commandFamily(for js: String) -> CommandFamily {
        if js.hasPrefix("nextPage") || js.hasPrefix("prevPage") {
            return .navigation
        }
        if js.hasPrefix("set") || js.hasPrefix("applyAppearance") {
            return .appearance
        }
        if js.hasPrefix("loadBook") {
            return .load
        }
        return .display
    }

    private static func syncKey(cfi: String, delta: Int) -> String {
        "\(cfi)|\(delta)"
    }

    private static func javaScriptStringLiteral(_ value: String) -> String {
        value
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "'", with: "\\'")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\r", with: "\\r")
            .replacingOccurrences(of: "\u{2028}", with: "\\u2028")
            .replacingOccurrences(of: "\u{2029}", with: "\\u2029")
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
        guard let url = URL(string: "\(Self.scheme)://book/\(token).epub") else {
            preconditionFailure("Generated EPUB URL contains only a fixed scheme, host, UUID token, and extension.")
        }
        return url
    }

    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        guard let requestURL = urlSchemeTask.request.url,
              let token = requestURL.pathComponents.last?.replacingOccurrences(of: ".epub", with: "")
        else {
            fail(urlSchemeTask, code: 400, reason: "Malformed EPUB URL")
            return
        }

        lock.lock()
        let fileURL = fileURLByToken[token]
        lock.unlock()

        guard let fileURL else {
            fail(urlSchemeTask, code: 404, reason: "Unknown EPUB token")
            return
        }

        do {
            let data = try Data(contentsOf: fileURL)
            guard let response = HTTPURLResponse(
                url: requestURL,
                statusCode: 200,
                httpVersion: "HTTP/1.1",
                headerFields: [
                    "Access-Control-Allow-Origin": "*",
                    "Content-Type": "application/epub+zip",
                    "Content-Length": String(data.count)
                ]
            ) else {
                fail(urlSchemeTask, code: 500, reason: "Unable to construct HTTP response")
                return
            }
            urlSchemeTask.didReceive(response)
            urlSchemeTask.didReceive(data)
            urlSchemeTask.didFinish()
        } catch {
            fail(urlSchemeTask, code: 500, reason: "Unable to read EPUB data")
        }
    }

    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {}

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
        canStartPageTurn(direction: .backward) ? prevSlot : nil
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        canStartPageTurn(direction: .forward) ? nextSlot : nil
    }
}

// MARK: - UIPageViewControllerDelegate

extension PageCurlViewController: UIPageViewControllerDelegate {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        willTransitionTo pendingViewControllers: [UIViewController]
    ) {
        isPageTransitionInProgress = true
        Log.shared.debug("PageCurl nativeCurlStarted direction=interactive")
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        defer {
            isPageTransitionInProgress = false
            isProgrammaticTurnInProgress = false
        }
        guard completed, let appearing = pageViewController.viewControllers?.first as? EPUBPageContentViewController else {
            return
        }
        completeNativeTurn(to: appearing)
        Log.shared.debug("PageCurl nativeCurlCompleted direction=interactive")
    }
}



// MARK: - PageCurlReaderView

/// `UIViewControllerRepresentable` that embeds ``PageCurlViewController``.
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
        coordinator.detach()
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    @MainActor
    final class Coordinator {
        private weak var viewModel: ReaderViewModel?
        private weak var controller: PageCurlViewController?

        func wire(_ vc: PageCurlViewController, to viewModel: ReaderViewModel) {
            self.viewModel = viewModel
            controller = vc
            viewModel.attachPageCurlController(vc)
            vc.onRelocated = { [weak viewModel, weak vc] cfi, pct, spineHref, characterOffset, contextSnippet in
                viewModel?.handleRelocated(
                    cfi: cfi,
                    pct: pct,
                    spineHref: spineHref,
                    characterOffset: characterOffset,
                    contextSnippet: contextSnippet,
                    atEnd: false,
                    pageCurlVC: vc
                )
            }
            vc.onBookReady = { [weak viewModel, weak vc] in
                Log.shared.info("EPUB book ready (PageCurl pool)")
                viewModel?.handleBookReady(in: vc)
            }
            vc.onBookError = { msg in
                Log.shared.error("EPUB reader error: \(msg)")
            }
            vc.onAtChapterEnd = { [weak viewModel, weak vc] in
                guard let viewModel else { return }
                viewModel.handleRelocated(
                    cfi: viewModel.currentCFI,
                    pct: viewModel.percentage,
                    spineHref: "",
                    characterOffset: 0,
                    contextSnippet: "",
                    atEnd: true,
                    pageCurlVC: vc
                )
            }
            vc.onLocationsSnapshot = { [weak viewModel] totalLocations, serializedLocations in
                viewModel?.handleLocationsSnapshot(
                    totalLocations: totalLocations,
                    serializedLocations: serializedLocations
                )
            }
            vc.onWordCountSample = { [weak viewModel] counts in
                viewModel?.handleWordCountSample(counts)
            }
            vc.onChapterWordCount = { [weak viewModel] index, count in
                viewModel?.handleChapterWordCount(index: index, count: count)
            }
            vc.onJavaScriptExecutionFailed = { [weak viewModel] failure in
                viewModel?.handleJavaScriptExecutionFailure(failure)
            }
            vc.onJSGuardBlocked = { [weak viewModel] _, event in
                viewModel?.handleJSGuardBlocked(event)
            }
        }

        func detach() {
            if viewModel?.pageCurlController === controller {
                viewModel?.detachPageCurlController()
            }
        }
    }
}
