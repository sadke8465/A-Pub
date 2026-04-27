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

    public struct JavaScriptExecutionFailure: Sendable {
        public let commandPrefix: String
        public let errorDomain: String
        public let errorCode: Int
        public let message: String
        public let slotIndex: Int?
        public let slotState: String?
        public let loadToken: Int?
        public let commandFamily: String?
    }

    public struct JSGuardBlockedEvent: Sendable {
        public let command: String
        public let reason: String
    }

    public struct JSDiagnosticEvent: Sendable {
        public let level: String
        public let message: String
        public let details: String?
    }

    public static let messageName = "bridge"

    public weak var webView: WKWebView?

    public var onRelocated: ((String, Double, String, Int64, String) -> Void)?
    public var onBookReady: (() -> Void)?
    public var onBookError: ((String) -> Void)?
    var onSelected: ((ReaderTextSelection) -> Void)?
    public var onMarkClicked: ((String) -> Void)?
    public var onRequestHighlights: ((String) -> Void)?
    public var onFootnoteRequest: ((String, String) -> Void)?
    public var onChapterLoaded: (() -> Void)?
    public var onAtChapterEnd: (() -> Void)?
    public var onLocationsSnapshot: ((Int, String?) -> Void)?
    public var onWordCountSample: (([Int]) -> Void)?
    public var onChapterWordCount: ((Int, Int) -> Void)?
    public var onJavaScriptExecutionFailed: ((JavaScriptExecutionFailure) -> Void)?
    public var onJSGuardBlocked: ((JSGuardBlockedEvent) -> Void)?
    public var onJSDiagnostic: ((JSDiagnosticEvent) -> Void)?

    public override init() {
        super.init()
    }

    /// Builds a `WKWebViewConfiguration` with the `bridge` message handler
    /// already wired through a ``LeakAvoider`` proxy and `file://`
    /// resource access enabled for the bundled reader assets.
    public func setup() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        let proxy = LeakAvoider(delegate: self)
        contentController.add(proxy, name: Self.messageName)
        configuration.userContentController = contentController
        return configuration
    }

    /// JavaScript evaluation in the bound web view with structured error handling.
    public func callJS(
        _ js: String,
        slotIndex: Int? = nil,
        slotState: String? = nil,
        loadToken: Int? = nil,
        commandFamily: String? = nil
    ) {
        webView?.evaluateJavaScript(js) { [weak self] _, error in
            guard let self else { return }
            if let nsError = error as NSError? {
                let commandPrefix = Self.truncatedCommandPrefix(for: js)
                Log.shared.error(
                    """
                    JS execution failed [domain=\(nsError.domain) code=\(nsError.code)]: \
                    \(nsError.localizedDescription) | commandPrefix=\(commandPrefix)
                    """
                )
                onJavaScriptExecutionFailed?(
                    JavaScriptExecutionFailure(
                        commandPrefix: commandPrefix,
                        errorDomain: nsError.domain,
                        errorCode: nsError.code,
                        message: nsError.localizedDescription,
                        slotIndex: slotIndex,
                        slotState: slotState,
                        loadToken: loadToken,
                        commandFamily: commandFamily
                    )
                )
                return
            }

            if js.hasPrefix("loadBook(") {
                Log.shared.info("loadBook invoked successfully")
            }
        }
    }

    /// Applies a named theme (light / dark / sepia) to the current rendition.
    public func applyTheme(_ theme: String) {
        callJS("setTheme('\(theme)')")
    }

    public func applyFontSize(_ px: Int) {
        callJS("setFontSize(\(px))")
    }

    public func applyFontFamily(_ family: String) {
        let escaped = family.replacingOccurrences(of: "'", with: "\\'")
        callJS("setFontFamily('\(escaped)')")
    }

    public func applyLineSpacing(_ value: Double) {
        callJS("setLineSpacing(\(value))")
    }

    public func applyMargin(_ px: Int) {
        callJS("setMargin(\(px))")
    }

    public func applyJustify(_ justify: Bool) {
        callJS("setJustify(\(justify))")
    }

    public func applyHyphenation(_ on: Bool) {
        callJS("setHyphenation(\(on))")
    }

    public func requestLocationsSnapshot() {
        callJS("snapshotLocations()")
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
            let characterOffset = body["characterOffset"] as? Int64 ?? 0
            let contextSnippet = body["contextSnippet"] as? String ?? ""
            onRelocated?(cfi, pct, spineHref, characterOffset, contextSnippet)
        case "bookReady":
            onBookReady?()
        case "bookError":
            let message = body["message"] as? String ?? "Unknown book load error"
            onBookError?(message)
        case "selected", "textSelected":
            let selection = Self.textSelection(from: body)
            onSelected?(selection)
        case "markClicked":
            let id = body["id"] as? String ?? ""
            onMarkClicked?(id)
        case "requestHighlights":
            let spineHref = body["spineHref"] as? String ?? ""
            onRequestHighlights?(spineHref)
        case "footnoteRequest":
            let href = body["href"] as? String ?? ""
            let text = body["text"] as? String ?? ""
            onFootnoteRequest?(href, text)
        case "chapterLoaded":
            onChapterLoaded?()
        case "atChapterEnd":
            onAtChapterEnd?()
        case "locationsSnapshot":
            let totalLocations = body["totalLocations"] as? Int ?? 0
            let serialized = body["serializedLocations"] as? String
            onLocationsSnapshot?(totalLocations, serialized)
        case "wordCountSample":
            let counts = body["counts"] as? [Int] ?? []
            onWordCountSample?(counts)
        case "chapterWordCount":
            let index = body["index"] as? Int ?? 0
            let count = body["count"] as? Int ?? 0
            onChapterWordCount?(index, count)
        case "jsGuardBlocked":
            let command = body["command"] as? String ?? "unknown"
            let reason = body["reason"] as? String ?? "unknown"
            onJSGuardBlocked?(JSGuardBlockedEvent(command: command, reason: reason))
        case "jsDiagnostic":
            let level = body["level"] as? String ?? "info"
            let message = body["message"] as? String ?? "(no message)"
            let details = body["details"] as? String
            let event = JSDiagnosticEvent(level: level, message: message, details: details)
            onJSDiagnostic?(event)
            if let details, !details.isEmpty {
                switch level {
                case "error":
                    Log.shared.error("JS diagnostic [\(level)]: \(message) | \(details)")
                case "warn":
                    Log.shared.info("JS diagnostic [\(level)]: \(message) | \(details)")
                default:
                    Log.shared.debug("JS diagnostic [\(level)]: \(message) | \(details)")
                }
            } else {
                switch level {
                case "error":
                    Log.shared.error("JS diagnostic [\(level)]: \(message)")
                case "warn":
                    Log.shared.info("JS diagnostic [\(level)]: \(message)")
                default:
                    Log.shared.debug("JS diagnostic [\(level)]: \(message)")
                }
            }
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

private extension EPUBBridge {
    static func textSelection(from body: [String: Any]) -> ReaderTextSelection {
        let cfiRange = body["cfiRange"] as? String ?? ""
        let text = body["text"] as? String ?? ""
        let rect = CGRect(
            x: numericValue(body["x"]),
            y: numericValue(body["y"]),
            width: numericValue(body["width"]),
            height: numericValue(body["height"])
        )
        return ReaderTextSelection(cfiRange: cfiRange, text: text, rect: rect)
    }

    static func numericValue(_ value: Any?) -> CGFloat {
        if let double = value as? Double {
            return CGFloat(double)
        }
        if let number = value as? NSNumber {
            return CGFloat(truncating: number)
        }
        return 0
    }

    static func truncatedCommandPrefix(for js: String, limit: Int = 120) -> String {
        let singleLine = js.replacingOccurrences(of: "\n", with: " ")
        guard singleLine.count > limit else {
            return singleLine
        }
        return "\(singleLine.prefix(limit))…"
    }
}
