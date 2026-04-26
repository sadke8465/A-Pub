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
}

// MARK: - PageCurlViewController

/// `UIPageViewController` that provides an Apple-Books–style page-curl
/// animation by cycling three ``EPUBPageContentViewController`` pool slots
/// (previous / current / next).  Swift drives each slot's epub.js rendition
/// via ``callJS(_:)``; UIKit owns the curl gesture and transition timing.
@MainActor
final class PageCurlViewController: UIPageViewController {

    private enum SlotLifecycleState: Equatable {
        case htmlLoaded
        case bookLoading(token: Int)
        case bookReady(token: Int)
        case failed(token: Int, error: String)

        var label: String {
            switch self {
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
            case .htmlLoaded:
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
    private var slotState = [SlotLifecycleState](repeating: .htmlLoaded, count: 3)
    private var isHTMLReadyBySlot = [Bool](repeating: false, count: 3)
    private var loadTokenBySlot = [Int](repeating: 0, count: 3)
    private var queuedCommandsBySlot = [[PendingCommand]](repeating: [], count: 3)
    private struct PendingLoad {
        let bookURLString: String
        let fallbackEscapedBase64: String?
    }
    private var pendingLoadBySlot = [PendingLoad?](repeating: nil, count: 3)

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
    var onJavaScriptExecutionFailed: ((EPUBBridge.JavaScriptExecutionFailure) -> Void)?
    var onJSGuardBlocked: ((Int, EPUBBridge.JSGuardBlockedEvent) -> Void)?

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
        dataSource = self
        delegate = self
        pool.forEach { slot in
            slot.onReaderHTMLReady = { [weak self] index in
                self?.markSlotReady(index)
            }
        }
        setViewControllers([currentSlot], direction: .forward, animated: false)
        wireCurrentSlotCallbacks()
        wireBridgeFailureCallbacks()
    }

    // MARK: Public API

    /// Load the same EPUB into every pool slot.  Only the current slot fires
    /// `onBookReady` to avoid triple-triggering the callback.
    func loadBook(fileURL: URL, fallbackEscapedBase64: String? = nil) {
        let bridgedURLString = EPUBFileSchemeHandler.shared.register(fileURL: fileURL).absoluteString
        for slotIndex in pool.indices {
            queueLoadIfNeeded(
                slotIndex: slotIndex,
                bookURLString: bridgedURLString,
                fallbackEscapedBase64: fallbackEscapedBase64
            )
        }
    }

    func displayCFI(_ cfi: String) {
        enqueueOrDispatch(slotIndex: poolCurrent, js: "displayCFI('\(cfi)')", family: .display)
    }

    /// Forward a JavaScript call to the current slot's rendition.
    func callJS(_ js: String) {
        enqueueOrDispatch(slotIndex: poolCurrent, js: js, family: commandFamily(for: js))
    }

    func applyAppearance(_ appearance: ReaderAppearance) {
        for slotIndex in pool.indices {
            enqueueOrDispatch(slotIndex: slotIndex, js: "setTheme('\(appearance.theme)')", family: .appearance)
            enqueueOrDispatch(slotIndex: slotIndex, js: "setFontSize(\(Int(appearance.fontSize)))", family: .appearance)
            let escapedFont = appearance.fontFamily.replacingOccurrences(of: "'", with: "\\'")
            enqueueOrDispatch(slotIndex: slotIndex, js: "setFontFamily('\(escapedFont)')", family: .appearance)
            enqueueOrDispatch(slotIndex: slotIndex, js: "setLineSpacing(\(appearance.lineSpacing))", family: .appearance)
            let margin: Int
            switch appearance.marginStyle {
            case "narrow": margin = 8
            case "wide": margin = 40
            default: margin = 24
            }
            enqueueOrDispatch(slotIndex: slotIndex, js: "setMargin(\(margin))", family: .appearance)
            enqueueOrDispatch(slotIndex: slotIndex, js: "setJustify(\(appearance.textAlignment == "justify"))", family: .appearance)
            enqueueOrDispatch(slotIndex: slotIndex, js: "setHyphenation(\(appearance.hyphenation))", family: .appearance)
        }
    }

    /// Tear down all pool bridges (call from `dismantleUIViewController`).
    func invalidatePool() {
        pool.forEach { $0.bridge.invalidate() }
    }

    // MARK: Callback wiring

    private func wireCurrentSlotCallbacks() {
        let slot = currentSlot
        slot.bridge.onRelocated = { [weak self] cfi, pct, href, offset, snippet in
            self?.onRelocated?(cfi, pct, href, offset, snippet)
        }
        slot.bridge.onBookError         = { [weak self] msg  in self?.onBookError?(msg) }
        slot.bridge.onSelected          = { [weak self] r, t in self?.onSelected?(r, t) }
        slot.bridge.onMarkClicked       = { [weak self] id   in self?.onMarkClicked?(id) }
        slot.bridge.onRequestHighlights = { [weak self] href in self?.onRequestHighlights?(href) }
        slot.bridge.onFootnoteRequest = { [weak self] href, text in
            self?.onFootnoteRequest?(href, text)
        }
        slot.bridge.onAtChapterEnd      = { [weak self] in
            self?.onAtChapterEnd?()
            // Pre-warm the next slot so its rendition is one chapter ahead.
            guard let self else { return }
            self.enqueueOrDispatch(slotIndex: self.nextSlot.slotIndex, js: "nextPage()", family: .navigation)
        }
    }

    private func wireBridgeFailureCallbacks() {
        pool.forEach { slot in
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
        }
    }

    private func clearCurrentSlotCallbacks() {
        let slot = currentSlot
        slot.bridge.onRelocated         = nil
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
    }

    // MARK: Pool rotation

    private func markSlotReady(_ slotIndex: Int) {
        isHTMLReadyBySlot[slotIndex] = true
        slotState[slotIndex] = .htmlLoaded
        Log.shared.debug("PageCurl slot \(slotIndex) state=\(slotState[slotIndex].label)")
        flushPendingLoad(for: slotIndex)
    }

    private func queueLoadIfNeeded(slotIndex: Int, bookURLString: String, fallbackEscapedBase64: String?) {
        loadTokenBySlot[slotIndex] += 1
        let token = loadTokenBySlot[slotIndex]
        queuedCommandsBySlot[slotIndex].removeAll()
        slotState[slotIndex] = .bookLoading(token: token)
        pendingLoadBySlot[slotIndex] = PendingLoad(
            bookURLString: bookURLString,
            fallbackEscapedBase64: fallbackEscapedBase64
        )
        Log.shared.debug("PageCurl slot \(slotIndex) state=\(slotState[slotIndex].label) token=\(token)")
        flushPendingLoad(for: slotIndex)
    }

    private func flushPendingLoad(for slotIndex: Int) {
        guard isHTMLReadyBySlot[slotIndex],
              case .bookLoading(let token) = slotState[slotIndex],
              let pendingLoad = pendingLoadBySlot[slotIndex]
        else { return }
        pendingLoadBySlot[slotIndex] = nil
        Log.shared.debug("PageCurl slot \(slotIndex) state=\(slotState[slotIndex].label) token=\(token) load dispatched")
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
        flushQueuedCommands(for: slotIndex)
        if slotIndex == poolCurrent {
            onBookReady?()
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

    private func enqueueOrDispatch(slotIndex: Int, js: String, family: CommandFamily) {
        switch slotState[slotIndex] {
        case .bookReady(let token):
            dispatch(js: js, to: slotIndex, token: token, family: family)
        case .bookLoading(let token):
            queuedCommandsBySlot[slotIndex].append(PendingCommand(js: js, family: family, token: token))
        case .htmlLoaded:
            return
        case .failed:
            queuedCommandsBySlot[slotIndex].removeAll()
        }
    }

    private func flushQueuedCommands(for slotIndex: Int) {
        guard case .bookReady(let token) = slotState[slotIndex] else { return }
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
        clearCurrentSlotCallbacks()
        poolCurrent = (poolCurrent + 1) % 3
        wireCurrentSlotCallbacks()
        // Advance the recycled slot so it tracks one page behind the new current.
        enqueueOrDispatch(slotIndex: prevSlot.slotIndex, js: "prevPage()", family: .navigation)
    }

    private func rotateBackward() {
        clearCurrentSlotCallbacks()
        poolCurrent = (poolCurrent + 2) % 3
        wireCurrentSlotCallbacks()
        // Retreat the recycled slot so it tracks one page ahead of the new current.
        enqueueOrDispatch(slotIndex: nextSlot.slotIndex, js: "nextPage()", family: .navigation)
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
        return URL(string: "\(Self.scheme)://book/\(token).epub")!
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
            let response = URLResponse(
                url: requestURL,
                mimeType: "application/epub+zip",
                expectedContentLength: data.count,
                textEncodingName: nil
            )
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
        prevSlot
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        nextSlot
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
        guard completed, let appearing = pageViewController.viewControllers?.first else { return }
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
        }
    }
}
