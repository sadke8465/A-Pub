@preconcurrency import SwiftUI
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

        context.coordinator.attach(to: webView)
        bridge.webView = webView

        if let htmlURL = Bundle.main.url(forResource: "reader", withExtension: "html") {
            webView.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL.deletingLastPathComponent())
        } else {
            Log.shared.error("reader.html missing from app bundle")
        }

        return webView
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        context.coordinator.resizeIfNeeded(for: uiView)
    }

    public final class Coordinator: NSObject, WKNavigationDelegate {
        private let bridge: EPUBBridge
        private weak var webView: WKWebView?
        private var currentSize: CGSize = .zero
        private var orientationObserver: NSObjectProtocol?

        init(bridge: EPUBBridge) {
            self.bridge = bridge
        }

        deinit {
            if let orientationObserver {
                NotificationCenter.default.removeObserver(orientationObserver)
            }
        }

        func attach(to webView: WKWebView) {
            self.webView = webView
            if orientationObserver == nil {
                orientationObserver = NotificationCenter.default.addObserver(
                    forName: UIDevice.orientationDidChangeNotification,
                    object: nil,
                    queue: .main
                ) { [weak self] _ in
                    MainActor.assumeIsolated {
                        guard let self, let webView = self.webView else { return }
                        self.currentSize = .zero
                        self.resizeIfNeeded(for: webView)
                    }
                }
            }
        }

        func resizeIfNeeded(for webView: WKWebView) {
            let newSize = webView.bounds.size
            guard newSize.width > 0, newSize.height > 0, newSize != currentSize else {
                return
            }

            currentSize = newSize
            let adjustedHeight = max(0, newSize.height - webView.safeAreaInsets.bottom)
            bridge.callJS("resizeRendition(\(newSize.width), \(adjustedHeight))")
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
