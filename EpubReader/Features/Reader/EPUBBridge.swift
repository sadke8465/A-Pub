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

    public struct RelocatedEvent: Sendable {
        public let cfi: String
        public let percentage: Double
        public let spineHref: String
        public let spineIndex: Int
        public let displayedPage: Int?
        public let displayedTotal: Int?
        public let characterOffset: Int64
        public let contextSnippet: String
        public let atStart: Bool
        public let atEnd: Bool
        public let source: String
    }

    public struct RenderStateEvent: Sendable {
        public let loadToken: Int
        public let phase: String
        public let hasReadableText: Bool
        public let textLength: Int
        public let iframeCount: Int
        public let managerViewCount: Int
        public let spineHref: String
        public let spineIndex: Int
        public let cfi: String
        public let percentage: Double?
        public let textExcerpt: String
    }

    public struct FirstContentReadyEvent: Sendable {
        public let loadToken: Int
        public let phase: String
        public let textLength: Int
        public let textExcerpt: String
        public let spineHref: String
        public let spineIndex: Int
    }

    public static let messageName = "bridge"
    private static let sharedProcessPool: AnyObject? = {
        guard let processPoolClass = NSClassFromString("WKProcessPool") as? NSObject.Type else {
            return nil
        }
        return processPoolClass.init()
    }()

    public weak var webView: WKWebView?

    public var onRelocated: ((String, Double, String, Int64, String) -> Void)?
    public var onBookReady: (() -> Void)?
    public var onBookError: ((String) -> Void)?
    public var onSelected: ((String, String) -> Void)?
    public var onMarkClicked: ((String) -> Void)?
    public var onRequestHighlights: ((String) -> Void)?
    public var onFootnoteRequest: ((String, String) -> Void)?
    public var onChapterLoaded: (() -> Void)?
    public var onAtChapterEnd: (() -> Void)?
    public var onLocationsSnapshot: ((Int, String?) -> Void)?
    public var onWordCountSample: (([Int]) -> Void)?
    public var onChapterWordCount: ((Int, Int) -> Void)?
    public var onRelocatedEvent: ((RelocatedEvent) -> Void)?
    public var onJavaScriptExecutionFailed: ((JavaScriptExecutionFailure) -> Void)?
    public var onJSGuardBlocked: ((JSGuardBlockedEvent) -> Void)?
    public var onJSDiagnostic: ((JSDiagnosticEvent) -> Void)?
    public var onRenderState: ((RenderStateEvent) -> Void)?
    public var onFirstContentReady: ((FirstContentReadyEvent) -> Void)?

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
        if let sharedProcessPool = Self.sharedProcessPool {
            configuration.setValue(sharedProcessPool, forKey: "processPool")
        }
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
            let event = RelocatedEvent(
                cfi: body["cfi"] as? String ?? "",
                percentage: Self.optionalDoubleValue(body["percentage"]) ?? Self.optionalDoubleValue(body["pct"]) ?? 0,
                spineHref: body["spineHref"] as? String ?? "",
                spineIndex: Self.intValue(body["spineIndex"]),
                displayedPage: Self.optionalIntValue(body["displayedPage"]),
                displayedTotal: Self.optionalIntValue(body["displayedTotal"]),
                characterOffset: Self.int64Value(body["characterOffset"]),
                contextSnippet: body["contextSnippet"] as? String ?? "",
                atStart: Self.boolValue(body["atStart"]),
                atEnd: Self.boolValue(body["atEnd"]),
                source: body["source"] as? String ?? "event"
            )
            onRelocatedEvent?(event)
            onRelocated?(
                event.cfi,
                event.percentage,
                event.spineHref,
                event.characterOffset,
                event.contextSnippet
            )
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
        case "renderState":
            let location = body["location"] as? [String: Any]
            let spine = body["spine"] as? [String: Any]
            let event = RenderStateEvent(
                loadToken: Self.intValue(body["loadToken"]),
                phase: body["phase"] as? String ?? "unknown",
                hasReadableText: Self.boolValue(body["hasReadableText"]),
                textLength: Self.intValue(body["textLength"]),
                iframeCount: Self.intValue(body["iframeCount"]),
                managerViewCount: Self.intValue(body["managerViewCount"]),
                spineHref: spine?["href"] as? String ?? "",
                spineIndex: Self.intValue(spine?["index"]),
                cfi: location?["cfi"] as? String ?? "",
                percentage: Self.optionalDoubleValue(location?["percentage"]),
                textExcerpt: body["textExcerpt"] as? String ?? ""
            )
            onRenderState?(event)
            Log.shared.debug(
                """
                JS renderState phase=\(event.phase) token=\(event.loadToken) \
                readable=\(event.hasReadableText) textLength=\(event.textLength) \
                iframes=\(event.iframeCount) views=\(event.managerViewCount) \
                spine=\(event.spineIndex):\(event.spineHref) cfi=\(event.cfi)
                """
            )
        case "firstContentReady":
            let event = FirstContentReadyEvent(
                loadToken: Self.intValue(body["loadToken"]),
                phase: body["phase"] as? String ?? "unknown",
                textLength: Self.intValue(body["textLength"]),
                textExcerpt: body["textExcerpt"] as? String ?? "",
                spineHref: body["spineHref"] as? String ?? "",
                spineIndex: Self.intValue(body["spineIndex"])
            )
            onFirstContentReady?(event)
            Log.shared.info(
                """
                JS firstContentReady token=\(event.loadToken) phase=\(event.phase) \
                textLength=\(event.textLength) spine=\(event.spineIndex):\(event.spineHref)
                """
            )
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
    static func truncatedCommandPrefix(for js: String, limit: Int = 120) -> String {
        let singleLine = js.replacingOccurrences(of: "\n", with: " ")
        guard singleLine.count > limit else {
            return singleLine
        }
        return "\(singleLine.prefix(limit))…"
    }

    static func intValue(_ value: Any?) -> Int {
        if let value = value as? Int {
            return value
        }
        if let value = value as? Double {
            return Int(value)
        }
        if let value = value as? NSNumber {
            return value.intValue
        }
        return 0
    }

    static func optionalIntValue(_ value: Any?) -> Int? {
        if let value = value as? Int {
            return value
        }
        if let value = value as? Double {
            return Int(value)
        }
        if let value = value as? NSNumber {
            return value.intValue
        }
        return nil
    }

    static func int64Value(_ value: Any?) -> Int64 {
        if let value = value as? Int64 {
            return value
        }
        if let value = value as? Int {
            return Int64(value)
        }
        if let value = value as? Double {
            return Int64(value)
        }
        if let value = value as? NSNumber {
            return value.int64Value
        }
        return 0
    }

    static func optionalDoubleValue(_ value: Any?) -> Double? {
        if let value = value as? Double {
            return value
        }
        if let value = value as? Int {
            return Double(value)
        }
        if let value = value as? NSNumber {
            return value.doubleValue
        }
        return nil
    }

    static func boolValue(_ value: Any?) -> Bool {
        if let value = value as? Bool {
            return value
        }
        if let value = value as? NSNumber {
            return value.boolValue
        }
        return false
    }
}
