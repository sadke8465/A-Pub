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

    // pool[poolCurrent]       = current (visible)
    // pool[(poolCurrent+2)%3] = previous
    // pool[(poolCurrent+1)%3] = next
    private let pool: [EPUBPageContentViewController]
    private var poolCurrent = 1
    private var slotReady = [Bool](repeating: false, count: 3)
    private var pendingEscapedBase64BySlot = [String?](repeating: nil, count: 3)

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
    var onAtChapterEnd:      (() -> Void)?

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
    }

    // MARK: Public API

    /// Load the same EPUB into every pool slot.  Only the current slot fires
    /// `onBookReady` to avoid triple-triggering the callback.
    func loadBook(escapedBase64: String) {
        pool.forEach { $0.bridge.onBookReady = nil }
        currentSlot.bridge.onBookReady = { [weak self] in self?.onBookReady?() }
        for slotIndex in pool.indices {
            queueLoadIfNeeded(slotIndex: slotIndex, escapedBase64: escapedBase64)
        }
    }

    func displayCFI(_ cfi: String) {
        currentSlot.bridge.callJS("displayCFI('\(cfi)')")
    }

    /// Forward a JavaScript call to the current slot's rendition.
    func callJS(_ js: String) {
        currentSlot.bridge.callJS(js)
    }

    func applyAppearance(_ appearance: ReaderAppearance) {
        pool.forEach { appearance.applyAll(via: $0.bridge) }
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
        slot.bridge.onAtChapterEnd      = { [weak self] in
            self?.onAtChapterEnd?()
            // Pre-warm the next slot so its rendition is one chapter ahead.
            self?.nextSlot.bridge.callJS("nextPage()")
        }
    }

    private func clearCurrentSlotCallbacks() {
        let slot = currentSlot
        slot.bridge.onRelocated         = nil
        slot.bridge.onBookReady         = nil
        slot.bridge.onBookError         = nil
        slot.bridge.onSelected          = nil
        slot.bridge.onMarkClicked       = nil
        slot.bridge.onRequestHighlights = nil
        slot.bridge.onAtChapterEnd      = nil
    }

    // MARK: Pool rotation

    private func markSlotReady(_ slotIndex: Int) {
        slotReady[slotIndex] = true
        Log.shared.debug("PageCurl slot \(slotIndex) ready=\(slotReady[slotIndex])")
        flushPendingLoad(for: slotIndex)
    }

    private func queueLoadIfNeeded(slotIndex: Int, escapedBase64: String) {
        pendingEscapedBase64BySlot[slotIndex] = escapedBase64
        Log.shared.debug("PageCurl slot \(slotIndex) ready=\(slotReady[slotIndex])")
        flushPendingLoad(for: slotIndex)
    }

    private func flushPendingLoad(for slotIndex: Int) {
        guard slotReady[slotIndex], let escapedBase64 = pendingEscapedBase64BySlot[slotIndex] else { return }
        pendingEscapedBase64BySlot[slotIndex] = nil
        Log.shared.debug("PageCurl slot \(slotIndex) ready=\(slotReady[slotIndex]) load dispatched")
        pool[slotIndex].bridge.callJS("loadBook('\(escapedBase64)')")
    }

    private func rotateForward() {
        clearCurrentSlotCallbacks()
        poolCurrent = (poolCurrent + 1) % 3
        wireCurrentSlotCallbacks()
        // Advance the recycled slot so it tracks one page behind the new current.
        prevSlot.bridge.callJS("prevPage()")
    }

    private func rotateBackward() {
        clearCurrentSlotCallbacks()
        poolCurrent = (poolCurrent + 2) % 3
        wireCurrentSlotCallbacks()
        // Retreat the recycled slot so it tracks one page ahead of the new current.
        nextSlot.bridge.callJS("nextPage()")
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
        onCreated(vc)
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
        }
    }
}
