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

    @Binding public var bridge: EPUBBridge

    public init(bridge: Binding<EPUBBridge>) {
        self._bridge = bridge
    }

    public func makeUIView(context: Context) -> WKWebView {
        let configuration = bridge.setup()
        let webView = WKWebView(frame: .zero, configuration: configuration)

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

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    /// Hands a base64-encoded EPUB payload to the JS `loadBook` entry point.
    public func loadBook(base64: String) {
        bridge.callJS("loadBook('\(base64)')")
    }

    /// Advances the rendition by one paginated page.
    public func nextPage() {
        bridge.callJS("nextPage()")
    }

    /// Returns the rendition to the previous paginated page.
    public func prevPage() {
        bridge.callJS("prevPage()")
    }

    @MainActor
    public final class Coordinator {
        var parent: EPUBWebView

        init(parent: EPUBWebView) {
            self.parent = parent
        }
    }
}

#if DEBUG
private struct EPUBWebViewPreviewHost: View {
    @State private var bridge = EPUBBridge()

    var body: some View {
        EPUBWebView(bridge: $bridge)
            .ignoresSafeArea()
    }
}

#Preview {
    EPUBWebViewPreviewHost()
}
#endif
