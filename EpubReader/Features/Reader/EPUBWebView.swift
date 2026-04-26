import SwiftUI
import WebKit

/// SwiftUI host for the epub.js `WKWebView` reader.
///
/// Bridges into UIKit because SwiftUI has no native `WKWebView`. The web
/// view is configured by ``EPUBBridge`` (which installs the
/// `WKScriptMessageHandler` through ``LeakAvoider``) and loads the
/// bundled `reader.html`. `allowingReadAccessTo` is set to the
/// Resources/ directory so that `epub.js` and `jszip.min.js` resolve as
/// siblings of the host page. Native scrolling and pinch-zoom are
/// disabled — pagination is owned entirely by epub.js, driven from
/// Swift through the bridge.
public struct EPUBWebView: UIViewRepresentable {

    public let bridge: EPUBBridge
    public let onWebViewReady: (() -> Void)?

    public init(bridge: EPUBBridge, onWebViewReady: (() -> Void)? = nil) {
        self.bridge = bridge
        self.onWebViewReady = onWebViewReady
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(onWebViewReady: onWebViewReady)
    }

    public func makeUIView(context: Context) -> WKWebView {
        let configuration = bridge.setup()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator

        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.minimumZoomScale = 1.0
        webView.scrollView.maximumZoomScale = 1.0
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear

        bridge.webView = webView

        if let htmlURL = Bundle.main.url(forResource: "reader", withExtension: "html") {
            webView.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL.deletingLastPathComponent())
        } else {
            Log.shared.error("reader.html missing from app bundle")
        }

        return webView
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
    }

    public final class Coordinator: NSObject, WKNavigationDelegate {
        private let onWebViewReady: (() -> Void)?

        init(onWebViewReady: (() -> Void)?) {
            self.onWebViewReady = onWebViewReady
        }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation?) {
            guard webView.url?.lastPathComponent == "reader.html" else {
                return
            }
            onWebViewReady?()
        }
    }
}

#if DEBUG
private struct EPUBWebViewPreviewHost: View {
    private let bridge = EPUBBridge()

    var body: some View {
        EPUBWebView(bridge: bridge)
            .ignoresSafeArea()
    }
}

#Preview {
    EPUBWebViewPreviewHost()
}
#endif
