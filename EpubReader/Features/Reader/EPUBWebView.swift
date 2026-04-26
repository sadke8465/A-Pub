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

    public init(bridge: EPUBBridge) {
        self.bridge = bridge
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(bridge: bridge)
    }

    public func makeUIView(context: Context) -> WKWebView {
        let configuration = bridge.setup()
        let viewportSource = "var m=document.createElement('meta');m.name='viewport';m.content='width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no';document.head.appendChild(m);"
        configuration.userContentController.addUserScript(
            WKUserScript(source: viewportSource, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        )
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
        private let bridge: EPUBBridge

        init(bridge: EPUBBridge) {
            self.bridge = bridge
        }

        public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            bridge.handleWebContentProcessTermination(webView)
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
