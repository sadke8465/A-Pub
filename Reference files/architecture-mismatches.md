## Audit Date: 2026-04-25

### Fixed in this session
* **Reader Web Rendering Infrastructure (EPUBBridge + EPUBWebView):** Reader web views were not sharing a single `WKProcessPool`, and web content process termination was not handled, which violated the master plan WKWebView lifecycle/memory invariants.
  * **Fix applied:** Configured `EPUBBridge` to use a shared static `WKProcessPool` for all reader web views. Added process termination handling via `WKNavigationDelegate.webViewWebContentProcessDidTerminate` in `EPUBWebView.Coordinator`, routing to a bridge recovery method that logs the fault and reloads the reader host page.

### Pending / Unfixed Mismatches
* **None identified at critical severity in current scope after this audit.**
  * **Why it wasn't fixed:** N/A.
  * **Recommended Next Steps:** Continue tracking medium/low-priority items separately and re-run architecture audit after major feature additions.
