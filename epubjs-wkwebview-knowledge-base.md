# epub.js + WKWebView iOS Reader — Knowledge Base

### Reference document for building a native iOS EPUB reader

-----

## Table of Contents

1. [epub.js Core](#1-epubjs-core)
1. [EPUB Format Internals](#2-epub-format-internals)
1. [CFI — Canonical Fragment Identifiers](#3-cfi--canonical-fragment-identifiers)
1. [WKWebView Bridge — Swift ↔ JS](#4-wkwebview-bridge--swift--js)
1. [WKWebView Memory & Performance](#5-wkwebview-memory--performance)
1. [Pagination Architecture](#6-pagination-architecture)
1. [Highlights & Annotations](#7-highlights--annotations)
1. [EPUB Asset Serving](#8-epub-asset-serving)
1. [Known Gotchas & Bugs](#9-known-gotchas--bugs)
1. [Apple Framework References](#10-apple-framework-references)
1. [Test EPUBs & Validation Tools](#11-test-epubs--validation-tools)
1. [Key GitHub Repositories](#12-key-github-repositories)
1. [Specs & Standards URLs](#13-specs--standards-urls)

-----

## 1. epub.js Core

### What it is

epub.js is a JavaScript library that renders EPUB files in any browser or WebView environment. It handles ZIP extraction (via JSZip), OPF parsing, spine navigation, CFI generation and resolution, CSS column-based pagination, and search.

**Primary repo:** `https://github.com/futurepress/epub.js`  
**Pinned stable version:** `0.3.93` (use this — do not CDN load, vendor locally)  
**API docs:** `https://epubjs.org/documentation/0.3/`  
**API markdown in repo:** `documentation/md/API.md`

### Core object model

```
Book               — The EPUB document. Parses container.xml → OPF → spine/manifest.
  └── Spine        — Ordered list of chapters (Section objects).
  └── Locations    — Generates CFI-based location percentages for progress tracking.
  └── Navigation   — TOC tree parsed from nav document or NCX.

Rendition          — Renders the Book into a DOM element. Manages layout and display.
  └── Manager      — Controls how sections are loaded (default = one at a time).
  └── Views        — The rendered iframes/columns for each section.
  └── Themes       — CSS injection API for fonts, colors, sizes.
  └── Annotations  — Highlight and mark API.

Contents           — Represents the DOM of the currently loaded section.
  └── document     — The actual XHTML document DOM inside the iframe.
  └── window       — The iframe's window object.
```

### Initialising a book

```javascript
// Load from binary (ArrayBuffer) — preferred for iOS where you pass the file bytes
const book = ePub(arrayBuffer, { openAs: 'binary' });

// Load from unzipped directory base URL (also works)
const book = ePub('file:///path/to/unzipped/epub/');

// Render to a DOM element with paginated layout
const rendition = book.renderTo('viewer', {
    width:  window.innerWidth,
    height: window.innerHeight,
    flow:   'paginated',  // or 'scrolled-continuous'
    spread: 'none'        // always single-page on phone
});

// Display from start (or from a stored CFI)
rendition.display('epubcfi(/6/4!/4/2/1:0)');
```

### Key Rendition events

```javascript
rendition.on('rendered', (section, view) => {
    // A section has finished rendering
});

rendition.on('relocated', (location) => {
    // Called after every page turn
    // location.start.cfi  — CFI of top of current page
    // location.start.percentage — 0-1 progress through book
    // location.atStart / location.atEnd — booleans
    window.webkit.messageHandlers.bridge.postMessage({
        type: 'relocated',
        cfi: location.start.cfi,
        percentage: location.start.percentage
    });
});

rendition.on('selected', (cfiRange, contents) => {
    // User selected text — cfiRange is a CFI string for the range
    window.webkit.messageHandlers.bridge.postMessage({
        type: 'textSelected',
        cfiRange: cfiRange,
        text: contents.window.getSelection().toString()
    });
});

rendition.on('markClicked', (cfiRange, data) => {
    // User tapped an existing highlight
});
```

### Navigation

```javascript
// Page turns
rendition.next();      // Next page or chapter
rendition.prev();      // Previous page or chapter

// Jump to location
rendition.display(cfiString);      // By CFI
rendition.display(0.5);            // By percentage (0-1)
rendition.display(spineIndex);     // By spine item index

// TOC
book.loaded.navigation.then(nav => {
    const toc = nav.toc; // Array of { label, href, subitems }
});
```

### Themes (CSS injection)

```javascript
// Register a theme
rendition.themes.register('dark', {
    'body': { 'background': '#1C1C1E', 'color': '#E5E5EA' },
    'p':    { 'line-height': '1.8' }
});

// Apply a theme
rendition.themes.select('dark');

// Override font size (overrides everything, including theme)
rendition.themes.fontSize('20px');

// Override font family
rendition.themes.font('Georgia');

// Inject arbitrary CSS
rendition.themes.override('margin', '40px');
rendition.themes.default({ 'p': { 'font-size': '1.1em' } });
```

### Hooks (intercept rendering pipeline)

```javascript
// Runs after each section's HTML is parsed but before display
rendition.hooks.content.register((contents, view) => {
    // `contents.document` is the XHTML DOM
    // Use this to inject highlight spans, custom CSS, etc.
    injectStoredHighlights(contents.document);
});

// Other hook points:
// book.spine.hooks.serialize  — section being serialised
// book.spine.hooks.content    — section loaded and parsed
// rendition.hooks.render      — section rendered to view
```

### Locations (progress calculation)

```javascript
// Generate locations — MUST be called after book opens
// n = chars per location chunk (~1024 is standard)
book.locations.generate(1024).then(() => {
    // Now you can convert CFI ↔ percentage
    const percentage = book.locations.percentageFromCfi(cfi);
    const cfi = book.locations.cfiFromPercentage(0.42);
    const location = book.locations.locationFromCfi(cfi); // integer index
});

// Cache generated locations to avoid regenerating on every open
const serialised = book.locations.save(); // JSON string — store in Core Data
book.locations.load(serialisedString);    // Restore from cache
```

### Search

```javascript
// Search within the current section
rendition.currentLocation().then(location => {
    book.spine.get(location.start.index).load(book.load.bind(book))
        .then(section => section.find('search term'))
        .then(results => {
            // results = [{ cfi, excerpt }]
        });
});

// Search entire book
const allResults = [];
book.spine.each(section => {
    section.load(book.load.bind(book))
        .then(s => s.find('search term'))
        .then(results => allResults.push(...results));
});
```

-----

## 2. EPUB Format Internals

### File structure

An EPUB is a ZIP file. When unzipped:

```
mimetype                         ← Must be first file, uncompressed, no header
META-INF/
  container.xml                  ← Points to the OPF file
OEBPS/ (or any name)
  content.opf                    ← Brain of the publication
  toc.ncx                        ← EPUB2 TOC (legacy, still present in many books)
  toc.xhtml                      ← EPUB3 Navigation Document (preferred)
  Text/
    chapter01.xhtml
    chapter02.xhtml
  Images/
    cover.jpg
  Styles/
    stylesheet.css
  Fonts/
    font.ttf
```

### container.xml

Always parse this first. It tells you where the OPF is.

```xml
<?xml version="1.0"?>
<container xmlns="urn:oasis:names:tc:opendocument:xmlns:container" version="1.0">
  <rootfiles>
    <rootfile full-path="OEBPS/content.opf"
              media-type="application/oebps-package+xml"/>
  </rootfiles>
</container>
```

**Parse with:** `XMLParser` (native Swift, no dependencies)

### OPF Package Document

The OPF contains four sections:

**1. metadata** — Dublin Core metadata

```xml
<metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
  <dc:title>Book Title</dc:title>
  <dc:creator>Author Name</dc:creator>
  <dc:language>en</dc:language>
  <dc:identifier id="bookid">urn:uuid:...</dc:identifier>
  <meta property="dcterms:modified">2023-01-01T00:00:00Z</meta>
</metadata>
```

**2. manifest** — Every file in the publication

```xml
<manifest>
  <item id="ch1"  href="Text/chapter1.xhtml" media-type="application/xhtml+xml"/>
  <item id="img1" href="Images/cover.jpg"    media-type="image/jpeg"
                                             properties="cover-image"/>
  <item id="toc"  href="toc.xhtml"           media-type="application/xhtml+xml"
                                             properties="nav"/>
  <item id="css1" href="Styles/main.css"     media-type="text/css"/>
</manifest>
```

Key `properties` values:

- `cover-image` — the cover image item
- `nav` — the EPUB3 navigation document
- `scripted` — contains JavaScript (be cautious)
- `mathml`, `svg` — special content types

**3. spine** — Reading order

```xml
<spine toc="ncx">  <!-- toc attr points to NCX id (EPUB2 compat) -->
  <itemref idref="cover" linear="no"/>  <!-- linear=no = ancillary content -->
  <itemref idref="ch1"/>
  <itemref idref="ch2"/>
</spine>
```

**4. guide** — Deprecated in EPUB3; use Navigation Document landmarks instead.

### EPUB3 Navigation Document (toc.xhtml)

```xml
<nav epub:type="toc">
  <ol>
    <li><a href="chapter1.xhtml">Chapter One</a></li>
    <li><a href="chapter2.xhtml">Chapter Two</a>
      <ol>
        <li><a href="chapter2.xhtml#section1">Section 2.1</a></li>
      </ol>
    </li>
  </ol>
</nav>
```

### EPUB2 NCX (toc.ncx)

Legacy but still common. Many ebooks on the wild are EPUB2 or EPUB3 with an NCX for compatibility. Always try the EPUB3 nav document first; fall back to NCX.

```xml
<ncx>
  <navMap>
    <navPoint id="navpoint-1" playOrder="1">
      <navLabel><text>Chapter One</text></navLabel>
      <content src="chapter1.xhtml"/>
    </navPoint>
  </navMap>
</ncx>
```

### Cover image extraction

In priority order:

1. OPF manifest item with `properties="cover-image"`
1. OPF metadata: `<meta name="cover" content="item-id"/>`
1. First image in the first spine item’s HTML
1. Item named `cover.jpg` / `cover.png` in manifest

### Swift parsing approach

```swift
// Unzip with ZIPFoundation (SPM: https://github.com/weichsel/ZIPFoundation)
let archive = try Archive(url: epubURL, accessMode: .read)

// Extract to temp directory
let tempDir = FileManager.default.temporaryDirectory
    .appendingPathComponent(UUID().uuidString)
try archive.extract(to: tempDir)

// Parse container.xml
let containerURL = tempDir.appendingPathComponent("META-INF/container.xml")
// → XMLParser → find rootfile full-path → resolve OPF path

// Parse OPF
let opfURL = tempDir.appendingPathComponent(opfPath)
// → XMLParser → extract metadata, manifest items, spine order
```

**ZIPFoundation SPM:** `https://github.com/weichsel/ZIPFoundation`

-----

## 3. CFI — Canonical Fragment Identifiers

### What a CFI is

A CFI uniquely identifies any location — or range of locations — inside an EPUB. It’s like a DOM XPath but for EPUB structure.

**Spec:** `https://idpf.org/epub/linking/cfi/`  
**W3C living draft:** `https://w3c.github.io/epub-specs/epub33/epubcfi/`

### Anatomy of a CFI

```
epubcfi(/6/4[chap01ref]!/4[body01]/10[para05]/3:5)
         │  │           │  │        │          │ └── Character offset (5th char)
         │  │           │  │        │          └── Text node (odd = text, even = element)
         │  │           │  │        └── 10th child of body (para05)
         │  │           │  └── 4th child of HTML root (body01)
         │  │           └── Indirection: step into referenced document
         │  └── 4th child of spine (2nd spine item, since indices are even)
         └── 6th child of package (= spine element; metadata=2, manifest=4, spine=6)
```

**Critical rules:**

- Only even numbers for element nodes
- Only odd numbers for text/CDATA nodes
- Adjacent text nodes are merged (treated as one)
- Whitespace-only text nodes between elements are assumed to exist
- `!` = indirection operator (step into a referenced document)
- `:N` = character offset into a text node
- `[id]` = optional element identifier for robustness (fallback if structure changes)

### Range CFI (for highlights)

```
epubcfi(/6/4!/4/2/1:10,/6/4!/4/2/1:40)
         └────────────┘ └────────────┘
         range start     range end
         (same path prefix, after the comma)
```

### epub.js CFI API

```javascript
// Get CFI of current position
const location = rendition.currentLocation();
const cfi = location.start.cfi;

// Navigate to CFI
rendition.display('epubcfi(/6/4!/4/2/1:0)');

// Get CFI range from a DOM Range object
const epubcfi = new window.ePub.CFI();
const cfiRange = epubcfi.fromRange(range, base);  // base = chapter CFI

// Resolve CFI range to DOM Range
const range = epubcfi.toRange(document, cfiRange);

// Compare two CFIs (returns -1, 0, 1)
const comparison = epubcfi.compare(cfi1, cfi2);
```

### Storing CFIs robustly

Always store:

1. The CFI string
1. The spine item href (fallback if CFI resolution fails)
1. A character offset as integer (last resort fallback)
1. A text snippet of 20-30 chars around the position (for fuzzy matching)

```swift
struct BookPosition: Codable {
    let cfi: String
    let spineHref: String       // e.g. "Text/chapter3.xhtml"
    let characterOffset: Int    // offset from chapter start
    let contextSnippet: String  // "...the quick brown fox..."
    let percentage: Double      // 0.0 - 1.0
    let savedAt: Date
}
```

### epub-cfi-resolver (JS library)

A standalone CFI parser/resolver — useful to understand the spec and as a reference implementation.

`https://github.com/fread-ink/epub-cfi-resolver`

```javascript
const CFI = require('epub-cfi-resolver');
const cfi = new CFI("epubcfi(/6/4[chap01ref]!/4[body01]/10[para05]/3:5)");
const bookmark = await cfi.resolve('chapter.xml');
// bookmark.node → DOM node
// bookmark.offset → character offset
```

-----

## 4. WKWebView Bridge — Swift ↔ JS

### Setup

```swift
import WebKit

class EPUBBridge: NSObject, WKScriptMessageHandler {

    weak var webView: WKWebView?
    private let config = WKWebViewConfiguration()

    func setup() -> WKWebView {
        let contentController = WKUserContentController()

        // Register all message handlers
        // CRITICAL: Use weak proxy to avoid retain cycle
        let proxy = LeakAvoider(delegate: self)
        contentController.add(proxy, name: "bridge")

        config.userContentController = contentController
        config.preferences.javaScriptCanOpenWindowsAutomatically = false

        // Allow file:// access for local EPUB assets
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")

        let webView = WKWebView(frame: .zero, configuration: config)
        self.webView = webView
        return webView
    }

    // MARK: — WKScriptMessageHandler
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        guard message.name == "bridge",
              let body = message.body as? [String: Any],
              let type = body["type"] as? String
        else { return }

        DispatchQueue.main.async {
            self.handleMessage(type: type, body: body)
        }
    }

    private func handleMessage(type: String, body: [String: Any]) {
        switch type {
        case "relocated":
            let cfi = body["cfi"] as? String ?? ""
            let pct = body["percentage"] as? Double ?? 0
            onRelocation?(cfi, pct)
        case "textSelected":
            let cfiRange = body["cfiRange"] as? String ?? ""
            let text     = body["text"] as? String ?? ""
            onTextSelected?(cfiRange, text)
        case "highlightTapped":
            let id = body["highlightId"] as? String ?? ""
            onHighlightTapped?(id)
        case "chapterLoaded":
            onChapterLoaded?()
        default:
            break
        }
    }

    // MARK: — Swift → JS
    func callJS(_ function: String, args: [Any] = []) {
        let argsJSON = (try? JSONSerialization.data(withJSONObject: args))
            .flatMap { String(data: $0, encoding: .utf8) } ?? "[]"
        let js = "\(function).apply(null, \(argsJSON));"
        webView?.evaluateJavaScript(js, completionHandler: nil)
    }

    // Callbacks
    var onRelocation: ((String, Double) -> Void)?
    var onTextSelected: ((String, String) -> Void)?
    var onHighlightTapped: ((String) -> Void)?
    var onChapterLoaded: (() -> Void)?
}
```

### The retain cycle problem — CRITICAL

`WKUserContentController` holds a **strong** reference to any added `WKScriptMessageHandler`. This creates:

```
WKWebView → WKUserContentController → YourHandler (strong)
YourHandler → WKWebView (if you hold it)  ← LEAK
```

**Fix: Use a weak proxy:**

```swift
// WeakScriptMessageHandler.swift
class LeakAvoider: NSObject, WKScriptMessageHandler {
    weak var delegate: WKScriptMessageHandler?

    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
    }

    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}
```

**Also: remove handlers on deinit:**

```swift
deinit {
    webView?.configuration.userContentController
        .removeScriptMessageHandler(forName: "bridge")
}
```

### JS → Swift (sending messages)

```javascript
// Always use message passing, never synchronous return values
window.webkit.messageHandlers.bridge.postMessage({
    type: 'relocated',
    cfi: rendition.currentLocation().start.cfi,
    percentage: rendition.currentLocation().start.percentage
});
```

### Swift → JS (calling functions)

```swift
// Fire and forget — use evaluateJavaScript
webView.evaluateJavaScript("rendition.next()") { _, error in
    if let error { print("JS error: \(error)") }
}

// With return value
webView.evaluateJavaScript("JSON.stringify(rendition.currentLocation())") { result, _ in
    guard let jsonString = result as? String,
          let data = jsonString.data(using: .utf8),
          let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    else { return }
    // use dict
}
```

### Injecting scripts at load time

```swift
let js = """
    // Your setup code
    window.readerReady = false;
"""
let script = WKUserScript(
    source: js,
    injectionTime: .atDocumentStart,  // or .atDocumentEnd
    forMainFrameOnly: true
)
config.userContentController.addUserScript(script)
```

### Loading the reader HTML

```swift
// Load HTML from app bundle — allows access to local files in the same directory
let htmlURL = Bundle.main.url(forResource: "reader", withExtension: "html")!
webView.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL.deletingLastPathComponent())
```

The `allowingReadAccessTo` path determines what local files the WKWebView can access. Set it to the parent folder of your reader HTML to allow it to load `epub.js`, `jszip.min.js`, etc.

### Passing EPUB data to JS

**Option A: Base64 encode the EPUB file, pass as string**

```swift
let epubData = try Data(contentsOf: epubURL)
let base64 = epubData.base64EncodedString()
let js = "loadBook('\(base64)');"
webView.evaluateJavaScript(js)
```

```javascript
function loadBook(base64) {
    const book = ePub(base64, { encoding: 'base64' });
    window.rendition = book.renderTo('viewer', { /* ... */ });
}
```

**Option B: Serve EPUB assets via a local HTTP server (WKURLSchemeHandler)**

More complex but handles large books and relative URL resolution better. See [Section 8](#8-epub-asset-serving).

**Option C: Unzip to app’s temp dir, load from file:// URLs**

Simplest for getting started. Unzip with ZIPFoundation, load `content.opf` via `file://` URL. Works well with `loadFileURL(_:allowingReadAccessTo:)`.

-----

## 5. WKWebView Memory & Performance

### The fundamental problem

WKWebView runs in a **separate process** (`com.apple.WebKit.WebContent`). This process consumes memory that doesn’t show up in your app’s memory footprint — it appears under “Other Processes” in Instruments. This makes it look like your app is fine, but the system may still kill it.

### Rules

**Rule 1: Never create more than 3 WKWebView instances.**

Creating a new WKWebView is one of the most expensive operations on iOS. Use a pool of 3: previous, current, next. Recycle aggressively.

```swift
class WKWebViewPool {
    private var pool: [WKWebView] = []
    private let configuration: WKWebViewConfiguration

    init(configuration: WKWebViewConfiguration) {
        self.configuration = configuration
        // Pre-warm 3 instances
        pool = (0..<3).map { _ in WKWebView(frame: .zero, configuration: configuration) }
    }

    func acquire() -> WKWebView {
        pool.popLast() ?? WKWebView(frame: .zero, configuration: configuration)
    }

    func recycle(_ webView: WKWebView) {
        webView.loadHTMLString("", baseURL: nil) // Clear content
        if pool.count < 3 { pool.append(webView) }
    }
}
```

**Rule 2: Share a single WKProcessPool across all WKWebView instances.**

```swift
let processPool = WKProcessPool() // Create ONCE, share everywhere
config.processPool = processPool
```

**Rule 3: Remove script message handlers before releasing.**

Not doing this causes the handler to stay alive, keeping your objects in memory.

**Rule 4: Handle `WKWebViewWebContentProcessDidTerminate`.**

The WebContent process can be killed by the OS under memory pressure. If you don’t handle this, the user sees a blank white screen.

```swift
webView.navigationDelegate = self

// WKNavigationDelegate
func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
    // Reload the current position
    webView.reload()
    // Or: re-navigate to the last saved CFI
    restoreLastPosition()
}
```

**Rule 5: Unload off-screen chapter content.**

When a chapter is no longer visible, clear its WKWebView:

```swift
offScreenWebView.loadHTMLString("", baseURL: nil)
```

**Rule 6: `evaluateJavaScript` with completion handler leaks memory on some iOS versions.**

Use the async version on iOS 14.5+:

```swift
// iOS 14.5+
let result = try await webView.evaluateJavaScript("someFunction()")
```

Or prefer message-passing over `evaluateJavaScript` wherever possible.

### Memory monitoring

```swift
// Register for memory warnings
NotificationCenter.default.addObserver(
    self,
    selector: #selector(didReceiveMemoryWarning),
    name: UIApplication.didReceiveMemoryWarningNotification,
    object: nil
)

@objc func didReceiveMemoryWarning() {
    // Clear off-screen webviews
    // Evict image caches
    // Release large data objects
}
```

### Performance: initial load time

epub.js loads the EPUB, parses the OPF, generates locations, and renders the first chapter. This pipeline takes time on large books.

Show a loading state, then:

```javascript
book.ready.then(() => {
    return book.locations.generate(1024);
}).then(() => {
    window.webkit.messageHandlers.bridge.postMessage({ type: 'bookReady' });
});
```

Cache the generated locations in Core Data and restore them on next open to skip the `generate()` call.

-----

## 6. Pagination Architecture

### CSS column-based pagination

This is how epub.js implements paginated flow. The EPUB chapter HTML is rendered into a single very wide `<div>` that uses CSS columns, each column-width equal to the viewport.

```javascript
rendition = book.renderTo('viewer', {
    flow:   'paginated',
    width:  window.innerWidth,
    height: window.innerHeight,
    spread: 'none',           // no side-by-side pages on phone
    minSpreadWidth: 9999      // disable spreads entirely
});
```

What epub.js does internally:

```css
/* Applied to the book content container */
column-width: 390px;     /* = viewport width */
column-gap:   0px;
column-fill:  auto;
height:       844px;     /* = viewport height */
overflow-x:   scroll;
overflow-y:   hidden;
```

The rendered chapter is then `N * viewport-width` pixels wide, where N = number of pages.

### Controlling the WKWebView scroll offset

```javascript
// Page N (0-indexed) is at x = N * window.innerWidth
function goToPage(n) {
    document.scrollingElement.scrollLeft = n * window.innerWidth;
}

function currentPage() {
    return Math.round(document.scrollingElement.scrollLeft / window.innerWidth);
}

function totalPages() {
    return Math.ceil(document.scrollingElement.scrollWidth / window.innerWidth);
}
```

### Gesture handling

Handle swipes in Swift, not in JS. This gives you full control over the physics.

```swift
let swipeLeft  = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
swipeLeft.direction = .left
let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
swipeRight.direction = .right

// Important: allow simultaneous recognition with webview's own gestures
func gestureRecognizer(_ g1: UIGestureRecognizer,
                       shouldRecognizeSimultaneouslyWith g2: UIGestureRecognizer) -> Bool {
    return true
}

@objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
    switch gesture.direction {
    case .left:  callJS("rendition.next()")
    case .right: callJS("rendition.prev()")
    default: break
    }
}
```

**Disable WKWebView’s built-in scrolling** for paginated mode — otherwise the user can scroll freely and pagination breaks:

```swift
webView.scrollView.isScrollEnabled = false
webView.scrollView.bounces = false
```

### Page turn animation

**Option A: Snapshot swap (simplest)**

1. Take snapshot of current webView state: `webView.takeSnapshot(with: nil)`
1. Call `rendition.next()`
1. When `relocated` fires, the new content is ready
1. Cross-dissolve between snapshot and live webView

```swift
webView.takeSnapshot(with: nil) { [weak self] image, error in
    guard let image else { return }
    let snapshot = UIImageView(image: image)
    self?.view.addSubview(snapshot)

    self?.callJS("rendition.next()")

    UIView.animate(withDuration: 0.3, delay: 0.15) {
        snapshot.alpha = 0
    } completion: { _ in
        snapshot.removeFromSuperview()
    }
}
```

**Option B: UIPageViewController curl**

Wrap each WKWebView in a `UIHostingController` or `UIViewController`. Use `UIPageViewController` with `.curl` transition style. Pre-render the next chapter into a second WKWebView. The curl animation is identical to Apple Books.

```swift
let pageVC = UIPageViewController(
    transitionStyle: .pageCurl,
    navigationOrientation: .horizontal
)
pageVC.dataSource = self
pageVC.delegate = self
```

**Note:** `UIPageViewController` requires you to supply `viewControllerBefore` and `viewControllerAfter` synchronously. Pre-warm the adjacent chapter’s WKWebView before the user reaches the end of the current chapter.

### Detecting end of chapter

```javascript
rendition.on('relocated', location => {
    if (location.atEnd) {
        window.webkit.messageHandlers.bridge.postMessage({
            type: 'atChapterEnd'
        });
        // Pre-load next chapter webview now
    }
});
```

-----

## 7. Highlights & Annotations

### How epub.js handles highlights

epub.js has a built-in annotations API, but it only persists in memory — you manage persistence yourself.

```javascript
// Add a highlight
rendition.annotations.highlight(
    cfiRange,               // CFI range string
    {},                     // data object (attach arbitrary metadata)
    (e) => {                // click callback
        window.webkit.messageHandlers.bridge.postMessage({
            type: 'highlightTapped',
            cfiRange: cfiRange
        });
    },
    'highlight',            // class name for CSS styling
    { fill: '#FEF08A', 'fill-opacity': '0.5' }  // CSS properties
);

// Remove a highlight
rendition.annotations.remove(cfiRange, 'highlight');

// Add an underline
rendition.annotations.underline(cfiRange, {}, callback, 'underline');

// Add a mark (no visual, just for TTS position tracking)
rendition.annotations.mark(cfiRange, {}, callback);
```

### Restoring highlights on chapter load

Highlights are lost when a chapter is re-rendered. Use the content hook:

```javascript
rendition.hooks.content.register(function(contents) {
    const chapterCfi = contents.cfiBase; // Base CFI for this chapter
    // Ask Swift for highlights that belong to this chapter
    window.webkit.messageHandlers.bridge.postMessage({
        type: 'requestHighlights',
        chapterCfi: chapterCfi
    });
});
```

Then from Swift, when you receive `requestHighlights`:

```swift
// Fetch highlights for this chapter from Core Data
let highlights = fetchHighlights(forChapterCFI: chapterCfi)
let json = try JSONEncoder().encode(highlights)
let jsonString = String(data: json, encoding: .utf8)!
callJS("applyHighlights(\(jsonString))")
```

```javascript
function applyHighlights(highlights) {
    highlights.forEach(h => {
        rendition.annotations.highlight(h.cfiRange, { id: h.id }, clickHandler, 'highlight',
            { fill: h.color, 'fill-opacity': '0.4' });
    });
}
```

### Custom highlight colors

Define CSS classes, apply via epub.js:

```javascript
// In reader.css (injected into WKWebView)
.highlight-yellow { background-color: rgba(254, 240, 138, 0.5) !important; }
.highlight-green  { background-color: rgba(187, 247, 208, 0.5) !important; }
.highlight-blue   { background-color: rgba(191, 219, 254, 0.5) !important; }
.highlight-pink   { background-color: rgba(251, 207, 232, 0.5) !important; }

// Apply with class name
rendition.annotations.highlight(cfiRange, {}, cb, 'highlight-yellow');
```

### Getting the selected text + CFI range

```javascript
rendition.on('selected', (cfiRange, contents) => {
    const selection = contents.window.getSelection();
    const selectedText = selection.toString().trim();

    window.webkit.messageHandlers.bridge.postMessage({
        type: 'textSelected',
        cfiRange: cfiRange,
        text: selectedText,
        // Also send bounding rect for positioning a custom menu
        rect: selection.getRangeAt(0).getBoundingClientRect()
    });
});
```

### Core Data schema for annotations

```swift
// Highlight entity
@objc(Highlight) class Highlight: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var bookID: UUID
    @NSManaged var cfiRange: String       // "epubcfi(/6/4!/...,...)"
    @NSManaged var cfiStart: String       // start only (for sorting)
    @NSManaged var spineHref: String      // chapter href for scoping
    @NSManaged var colorName: String      // "yellow", "green", etc.
    @NSManaged var selectedText: String   // stored for export/search
    @NSManaged var note: String?          // user's note
    @NSManaged var createdAt: Date
    @NSManaged var updatedAt: Date
}
```

-----

## 8. EPUB Asset Serving

### The challenge

WKWebView has strict security policies. `file://` access is limited. When epub.js renders a chapter, it needs to load CSS, fonts, and images relative to the chapter’s URL. If those relative URLs don’t resolve, images and fonts silently fail.

### Option A: loadFileURL with allowingReadAccessTo (simplest)

Unzip the EPUB to a temp directory. Load the reader HTML, grant read access to the entire temp directory.

```swift
let tempDir = FileManager.default.temporaryDirectory
    .appendingPathComponent(bookID.uuidString)
// Unzip epub into tempDir...

webView.loadFileURL(readerHTML, allowingReadAccessTo: tempDir)
```

In JS, pass the `file://` base URL to epub.js:

```javascript
const bookPath = `file://${tempDirPath}/`;
const book = ePub(bookPath + 'content.opf');
```

**Limitation:** The `allowFileAccessFromFileURLs` preference may need enabling (see Section 4 setup).

### Option B: WKURLSchemeHandler (robust, production-grade)

Register a custom URL scheme. epub.js loads assets via `epub://book-id/path/to/asset`. Your Swift handler intercepts these, reads the file from disk, and returns it.

```swift
class EPUBSchemeHandler: NSObject, WKURLSchemeHandler {
    let bookExtractedURL: URL

    func webView(_ webView: WKWebView, start task: WKURLSchemeTask) {
        guard let url = task.request.url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else { task.didFailWithError(EPUBError.invalidURL); return }

        // Map epub://book-id/OEBPS/Text/chapter1.xhtml
        // to /app/books/book-id/OEBPS/Text/chapter1.xhtml
        let relativePath = components.path.dropFirst() // remove leading /
        let fileURL = bookExtractedURL.appendingPathComponent(String(relativePath))

        do {
            let data = try Data(contentsOf: fileURL)
            let mimeType = mimeType(for: fileURL.pathExtension)
            let response = URLResponse(
                url: url,
                mimeType: mimeType,
                expectedContentLength: data.count,
                textEncodingName: "utf-8"
            )
            task.didReceive(response)
            task.didReceive(data)
            task.didFinish()
        } catch {
            task.didFailWithError(error)
        }
    }

    func webView(_ webView: WKWebView, stop task: WKURLSchemeTask) {}

    private func mimeType(for ext: String) -> String {
        switch ext.lowercased() {
        case "xhtml", "html": return "application/xhtml+xml"
        case "css":           return "text/css"
        case "jpg", "jpeg":   return "image/jpeg"
        case "png":           return "image/png"
        case "gif":           return "image/gif"
        case "svg":           return "image/svg+xml"
        case "ttf":           return "font/ttf"
        case "otf":           return "font/otf"
        case "woff":          return "font/woff"
        case "woff2":         return "font/woff2"
        case "js":            return "text/javascript"
        default:              return "application/octet-stream"
        }
    }
}

// Register during WKWebViewConfiguration setup
let handler = EPUBSchemeHandler(bookExtractedURL: extractedURL)
config.setURLSchemeHandler(handler, forURLScheme: "epub")
```

**Note:** Custom URL scheme handlers cannot be used for the main frame navigation (the reader HTML itself) — only for sub-resources. Load your `reader.html` via `file://` or `loadHTMLString`, then use the custom scheme for all book assets.

-----

## 9. Known Gotchas & Bugs

### epub.js

**Pagination breaks on chapters with very little content**
Short chapters may not produce a full page. epub.js may show a blank area. Mitigation: detect single-page chapters and skip the column layout for them.

**`locations.generate()` is slow on large books**
A 600-chapter book can take 5–10 seconds. Always run on a background thread (epub.js runs in JS, which runs on the WKWebView’s process — you can’t easily background it). Cache the result.

**CFI positions drift after font-size changes**
Column layout reflows the text. A CFI that pointed to a word on page 5 may now be on page 8. epub.js handles this gracefully via `rendition.display(cfi)` — it re-resolves the CFI after each reflow. Never store raw page numbers.

**`selected` event fires on tap (not just drag)**
A single tap also briefly selects then deselects text, which fires `selected` with an empty string. Filter these:

```javascript
rendition.on('selected', (cfiRange, contents) => {
    const text = contents.window.getSelection().toString().trim();
    if (text.length < 2) return; // ignore accidental selections
    // ...
});
```

**epub.js 0.3.x is not actively maintained**
The main `futurepress/epub.js` repo has low commit activity. It works well for standard EPUBs but has edge cases with some EPUB3 features (media overlays, scripted content). Check issues before building on unusual features.

**JSZip is required for archived EPUBs**
If you load a `.epub` file (ZIP), you must include `jszip.min.js` before `epub.js`. Without it, epub.js will silently fail to open the file.

### WKWebView

**`WKWebView` ignores `allowFileAccessFromFileURLs` silently on iOS 16.4+**
The private preference key changed. Use `WKWebpagePreferences` and `allowsContentJavaScript` instead. Test on device, not just simulator.

**WKWebView content process terminates under memory pressure**
Never show a blank screen — always catch `webViewWebContentProcessDidTerminate` and reload. See Section 5.

**`evaluateJavaScript` has a memory leak on iOS 16.x**
Confirmed Apple bug. Prefer `callAsyncJavaScript` on iOS 14.5+ or message-passing for frequent calls.

**Zooming breaks pagination**
Disable zoom in WKWebView:

```swift
webView.scrollView.minimumZoomScale = 1.0
webView.scrollView.maximumZoomScale = 1.0
webView.scrollView.zoomScale = 1.0
```

Or inject a viewport meta tag:

```javascript
// Injected into book content via hooks
const meta = document.createElement('meta');
meta.name = 'viewport';
meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
document.head.appendChild(meta);
```

**Right-to-left EPUBs**
Hebrew/Arabic EPUBs set `page-progression-direction="rtl"` in the OPF spine. You must reverse swipe directions and change the column scroll direction. epub.js handles RTL rendering in CSS, but you must detect and handle the gesture reversal in Swift.

**iOS Safe Area and column calculation**
The bottom safe area (home bar) affects the available height for rendering. If you don’t account for it, the last line of text on each page gets clipped. Always subtract `safeAreaInsets.bottom` from the rendition height.

```swift
let availableHeight = view.bounds.height
    - view.safeAreaInsets.top
    - view.safeAreaInsets.bottom
callJS("rendition.resize(\(view.bounds.width), \(availableHeight))")
```

-----

## 10. Apple Framework References

### PDFKit

Apple’s native PDF rendering. For the PDF reading feature.

- `PDFView` — renders PDFs with built-in scroll, zoom, search
- `PDFDocument` — load, page count, metadata
- `PDFAnnotation` — highlights, notes, links
- `PDFSelection` — text selection and search results
- Docs: `https://developer.apple.com/documentation/pdfkit`

### AVSpeechSynthesizer (TTS)

- `AVSpeechSynthesizer` — controls playback
- `AVSpeechUtterance` — a unit of text to speak
- `AVSpeechSynthesizerDelegate` — word boundary callbacks (use for sentence highlighting)
- `AVSpeechSynthesisVoice` — list available voices, filter by language
- Lock screen / AirPods: `MPRemoteCommandCenter` + `MPNowPlayingInfoCenter`
- Docs: `https://developer.apple.com/documentation/avfoundation/avspeechsynthesizer`

### Core Data + CloudKit

- `NSPersistentCloudKitContainer` — drop-in replacement for `NSPersistentContainer` that syncs to CloudKit automatically
- Setup: `container.persistentStoreDescriptions.first?.setOption(true, forKey: NSPersistentHistoryTrackingKey)`
- Conflict policy: `.mergeByPropertyObjectTrump` for last-write-wins
- Docs: `https://developer.apple.com/documentation/coredata/mirroring_a_core_data_store_with_cloudkit`

### WKWebView

- Main class: `WKWebView`
- Configuration: `WKWebViewConfiguration`, `WKPreferences`, `WKWebpagePreferences`
- Bridge: `WKUserContentController`, `WKScriptMessageHandler`, `WKUserScript`
- Asset serving: `WKURLSchemeHandler`
- NSHipster reference: `https://nshipster.com/wkwebview/`
- Docs: `https://developer.apple.com/documentation/webkit/wkwebview`

### Core Spotlight

- Index books and annotations for system search
- `CSSearchableItem`, `CSSearchableItemAttributeSet`
- `CSSearchableIndex.default().indexSearchableItems()`
- Docs: `https://developer.apple.com/documentation/corespotlight`

### WidgetKit

- Lock screen widgets (iOS 16+): `AccessoryRectangular`, `AccessoryCircular`, `AccessoryInline`
- Home screen widgets: `SystemSmall`, `SystemMedium`
- Docs: `https://developer.apple.com/documentation/widgetkit`

### Dynamic Island

- Live Activities via `ActivityKit`
- Docs: `https://developer.apple.com/documentation/activitykit`

-----

## 11. Test EPUBs & Validation Tools

### Test books

|Source           |URL                                                          |Why use it                                |
|-----------------|-------------------------------------------------------------|------------------------------------------|
|Standard Ebooks  |`https://standardebooks.org`                                 |Clean, well-formed EPUB3, free            |
|EPUB3 test suite |`https://github.com/IDPF/epub3-samples`                      |Edge cases, accessibility, RTL, media     |
|Project Gutenberg|`https://www.gutenberg.org`                                  |Real-world messy EPUB2 files              |
|Moby Dick sample |`https://standardebooks.org/ebooks/herman-melville/moby-dick`|Classic test case                         |
|epubtest.org     |`https://epubtest.org`                                       |Conformance test files for reading systems|

### Always test against

- A 500+ page novel (performance)
- A book with complex CSS (layout)
- A book with images (asset serving)
- An EPUB2 book (NCX parsing fallback)
- An RTL book in Hebrew or Arabic
- A book with footnotes and endnotes
- A fixed-layout EPUB (to confirm graceful failure/limitation)

### Validation tools

**EPUBCheck** — The official validator. Run on every test book.

```bash
# Java required
java -jar epubcheck.jar yourbook.epub
```

Download: `https://github.com/w3c/epubcheck`

**Ace by DAISY** — Accessibility checker

```bash
npm install -g @daisy/ace
ace yourbook.epub
```

`https://daisy.github.io/ace/`

-----

## 12. Key GitHub Repositories

|Repo                         |Stars|Purpose                                            |
|-----------------------------|-----|---------------------------------------------------|
|`futurepress/epub.js`        |~6k  |The EPUB rendering library you’re building on      |
|`groue/GRDB.swift`           |8.3k |SQLite + FTS5 for library search                   |
|`weichsel/ZIPFoundation`     |~2k  |EPUB unzipping in Swift                            |
|`readium/swift-toolkit`      |~330 |Reference for how a production reader is structured|
|`jimjatt1999/Auread`         |~4   |Minimal SwiftUI + EPUB reader to study             |
|`ismaelcompsci/Swift-Reader` |—    |SwiftUI book reader to study                       |
|`fread-ink/epub-cfi-resolver`|—    |Standalone CFI parser for understanding CFI        |
|`futurepress/epubjs-reader`  |—    |Reference reader app built on epub.js              |
|`IDPF/epub3-samples`         |—    |Test EPUB files                                    |
|`w3c/epubcheck`              |—    |EPUB validation tool                               |

-----

## 13. Specs & Standards URLs

|Document               |URL                                                                                           |
|-----------------------|----------------------------------------------------------------------------------------------|
|EPUB 3.3 Core (W3C)    |`https://www.w3.org/TR/epub-33/`                                                              |
|EPUB 3.3 Editor’s Draft|`https://w3c.github.io/epub-specs/epub33/core/`                                               |
|EPUB CFI 1.1 (IDPF)    |`https://idpf.org/epub/linking/cfi/`                                                          |
|EPUB CFI (W3C living)  |`https://w3c.github.io/epub-specs/epub33/epubcfi/`                                            |
|EPUB Packages 3.2      |`https://w3c.github.io/epub-specs/archive/epub32/spec/epub-packages.html`                     |
|EPUB 3 Anatomy (EDRLab)|`https://www.edrlab.org/open-standards/anatomy-of-an-epub-3-file/`                            |
|OPDS 1.2               |`https://specs.opds.io/opds-1.2`                                                              |
|KOReader Sync Server   |`https://github.com/koreader/koreader-sync-server`                                            |
|epub.js API docs       |`https://epubjs.org/documentation/0.3/`                                                       |
|WKWebView docs         |`https://developer.apple.com/documentation/webkit/wkwebview`                                  |
|NSHipster WKWebView    |`https://nshipster.com/wkwebview/`                                                            |
|CloudKit + Core Data   |`https://developer.apple.com/documentation/coredata/mirroring_a_core_data_store_with_cloudkit`|
|PDFKit docs            |`https://developer.apple.com/documentation/pdfkit`                                            |
|AVSpeechSynthesizer    |`https://developer.apple.com/documentation/avfoundation/avspeechsynthesizer`                  |
|Standard Ebooks        |`https://standardebooks.org`                                                                  |
|epubtest.org           |`https://epubtest.org`                                                                        |
|EPUBCheck              |`https://github.com/w3c/epubcheck`                                                            |

-----

## Quick Reference: Common Mistakes

|Mistake                                         |Fix                                             |
|------------------------------------------------|------------------------------------------------|
|Adding message handler without weak proxy       |Use `LeakAvoider` wrapper                       |
|Creating WKWebView per chapter                  |Pool of 3, recycle                              |
|Not handling content process termination        |Implement `webViewWebContentProcessDidTerminate`|
|Storing page numbers instead of CFIs            |Always store CFI + percentage                   |
|Not caching `locations.generate()` result       |Serialize and store in Core Data                |
|Not disabling WKWebView scroll in paginated mode|`scrollView.isScrollEnabled = false`            |
|Not subtracting safe area from rendition height |Bottom safe area clips last text line           |
|Not injecting viewport meta to disable zoom     |Pinch zoom breaks column layout                 |
|Loading JSZip after epub.js                     |JSZip must be loaded first                      |
|Firing `textSelected` on empty selections       |Filter `if text.length < 2`                     |

-----

*Last updated: April 2026*
