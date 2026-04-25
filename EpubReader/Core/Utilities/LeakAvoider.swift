import Foundation
import WebKit

/// Weak proxy that breaks the strong reference `WKUserContentController`
/// keeps on a `WKScriptMessageHandler`.
///
/// `WKUserContentController.add(_:name:)` retains its handler. If that
/// handler is the same object that owns (or is owned by) the `WKWebView`,
/// the configuration → controller → handler → web-view chain prevents
/// deinit. Routing through this proxy keeps the registered reference
/// strong while the actual delegate stays weak, allowing the bridge to
/// be released when its owner goes away.
@MainActor
public final class LeakAvoider: NSObject, WKScriptMessageHandler {

    public weak var delegate: (any WKScriptMessageHandler)?

    public init(delegate: any WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }

    public func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}
