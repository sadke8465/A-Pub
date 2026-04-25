import Foundation
import WebKit

/// Bidirectional Swift ↔ JavaScript bridge for the epub.js host page.
///
/// `setup()` produces a fully-wired `WKWebViewConfiguration` whose
/// `userContentController` is registered for the `bridge` message channel
/// via a ``LeakAvoider`` so the web view can deinit cleanly. JS posts
/// messages with `window.webkit.messageHandlers.bridge.postMessage(...)`;
/// they are dispatched to typed callbacks on this object. Swift drives
/// the page by calling ``callJS(_:)``.
///
/// The `webView` reference is intentionally `weak` — the `WKWebView`
/// owns the configuration that owns the proxy that points back here, so
/// any strong reverse link would form a retain cycle.
@MainActor
public final class EPUBBridge: NSObject, WKScriptMessageHandler {

    public static let messageName = "bridge"
    private static let sharedProcessPool = WKProcessPool()

    public weak var webView: WKWebView?

    public var onRelocated: ((String, Double, String) -> Void)?
    public var onBookReady: (() -> Void)?
    public var onBookError: ((String) -> Void)?
    public var onSelected: ((String, String) -> Void)?
    public var onMarkClicked: ((String) -> Void)?
    public var onRequestHighlights: ((String) -> Void)?
    public var onChapterLoaded: (() -> Void)?
    public var onAtChapterEnd: (() -> Void)?

    public override init() {
        super.init()
    }

    /// Builds a `WKWebViewConfiguration` with the `bridge` message handler
    /// already wired through a ``LeakAvoider`` proxy and `file://`
    /// resource access enabled for the bundled reader assets.
    public func setup() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.processPool = Self.sharedProcessPool
        let contentController = WKUserContentController()
        let proxy = LeakAvoider(delegate: self)
        contentController.add(proxy, name: Self.messageName)
        configuration.userContentController = contentController
        return configuration
    }

    /// Fire-and-forget JavaScript evaluation in the bound web view.
    public func callJS(_ js: String) {
        webView?.evaluateJavaScript(js, completionHandler: nil)
    }

    public func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        guard message.name == Self.messageName,
              let body = message.body as? [String: Any],
              let type = body["type"] as? String
        else {
            return
        }

        switch type {
        case "relocated":
            let cfi = body["cfi"] as? String ?? ""
            let pct = (body["percentage"] as? Double) ?? (body["pct"] as? Double) ?? 0
            let spineHref = body["spineHref"] as? String ?? ""
            onRelocated?(cfi, pct, spineHref)
        case "bookReady":
            onBookReady?()
        case "bookError":
            let message = body["message"] as? String ?? "Unknown book load error"
            onBookError?(message)
        case "selected":
            let cfiRange = body["cfiRange"] as? String ?? ""
            let text = body["text"] as? String ?? ""
            onSelected?(cfiRange, text)
        case "markClicked":
            let id = body["id"] as? String ?? ""
            onMarkClicked?(id)
        case "requestHighlights":
            let spineHref = body["spineHref"] as? String ?? ""
            onRequestHighlights?(spineHref)
        case "chapterLoaded":
            onChapterLoaded?()
        case "atChapterEnd":
            onAtChapterEnd?()
        default:
            Log.shared.debug("EPUBBridge received unknown message type: \(type)")
        }
    }

    public func invalidate() {
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: Self.messageName)
        webView = nil
    }

    public func handleWebContentProcessTermination(_ terminatedWebView: WKWebView) {
        Log.shared.error("WKWebView content process terminated; reloading reader host page")
        terminatedWebView.reload()
    }

    deinit {
        // Cleanup is expected to be explicit via `invalidate()` by the owner.
    }
}
