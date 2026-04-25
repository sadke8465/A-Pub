<!--
  PLAN.md — EpubReader iOS
  THIS FILE IS FOR LLM EYES ONLY. It is both the spec and the live execution log.
  Claude Code reads this file, executes the next unchecked task, checks it off, and updates STATE.
  Do not reformat or summarize this file. Treat it as source of truth.
-->

<!-- ============================================================
  EXECUTION PROTOCOL
  Read this every time before doing anything.
============================================================ -->

WHEN TOLD “execute the next step” OR SIMILAR:

1. Read STATE block below. Find NEXT_TASK.
1. Locate that task ID in TASKS. Read its IMPL and VERIFY lines.
1. Execute: create or modify the file(s) listed in TARGET.
1. Run VERIFY condition. If it fails, fix until it passes.
1. Mark the task [x] in TASKS.
1. Update STATE: set LAST_COMPLETED = this task ID, set NEXT_TASK = next [ ] task ID.
1. If the completed task is a GATE, record it in STATE.GATES_PASSED.
1. Write the updated PLAN.md back to disk.
1. Report: “Completed [task ID]: [task title]. Next: [next task ID].”

WHEN TOLD “what’s next” OR “show status”:
Read STATE. Report LAST_COMPLETED, NEXT_TASK, GATES_PASSED, and count of [x] vs [ ] tasks.

WHEN TOLD “execute task X.X”:
Jump to that specific task. Follow steps 3–9 above.

NEVER:

- Skip a task without marking it.
- Mark a task [x] before VERIFY passes.
- Modify INVARIANTS or ARCH sections.
- Add comments to Swift files unless they are doc comments (///).
- Use third-party UI frameworks.
- Generate code that does not compile.

<!-- ============================================================
  STATE
  Update this block after every completed task.
============================================================ -->

LAST_COMPLETED  = 0.8
NEXT_TASK       = 0.9
GATES_PASSED    = []
TASKS_DONE      = 8
TASKS_TOTAL     = 93

GATE_1_TESTFLIGHT_ALPHA  = requires 3b.6 done   (reading + full annotations)
GATE_2_TESTFLIGHT_BETA   = requires 6c.5 done   (all features + sync + integrations)
GATE_3_APPSTORE_V1       = requires 7b.6 done   (polish + accessibility + widgets)
GATE_4_V1_1              = requires 8.8 done    (PDF complete)

<!-- ============================================================
  INVARIANTS
  Apply to every single task. Never deviate.
============================================================ -->

LANG          Swift 6, strict concurrency
PLATFORM      iOS 17+, iPadOS 17+
PROJECT_NAME  EpubReader
BUNDLE_ID     com.yourname.epubreader
UI_FRAMEWORK  SwiftUI primary; UIKit via UIViewRepresentable/UIViewControllerRepresentable only where SwiftUI cannot do it
THIRD_PARTY   Only: ZIPFoundation, GRDB.swift. Nothing else. No SnapKit, no Lottie, no Alamofire.
CODE_QUALITY  Zero compiler errors. Zero compiler warnings. Zero force-unwraps except where value is guaranteed by construction (add inline comment explaining why).
SWIFT_CONC    All Core Data writes on backgroundContext. All UI updates on MainActor.
MEMORY        WKWebView: max 3 instances pooled, share one WKProcessPool, always use LeakAvoider proxy for WKScriptMessageHandler, remove handlers in deinit, handle webViewWebContentProcessDidTerminate.
HAPTICS       Gate every UIFeedbackGenerator call on !UIAccessibility.isReduceMotionEnabled
ANIMATION     Gate every animation on !UIAccessibility.isReduceMotionEnabled via @Environment(.accessibilityReduceMotion)
KEYCHAIN      Credentials (passwords, tokens, API keys) always in Keychain, never UserDefaults.
ERRORS        Never silently swallow errors. Log with Logger. Surface to user only if actionable.
IMPORTS       No circular imports. Feature modules import Core, never each other.

<!-- ============================================================
  ARCH
  Consult when implementing any task. Do not modify.
============================================================ -->

STACK:
UI              SwiftUI + UIKit bridges
EPUB render     WKWebView + epub.js 0.3.93 (vendored in Resources/, no CDN)
JS bridge       WKScriptMessageHandler via LeakAvoider weak proxy
PDF             PDFKit native
Persistence     Core Data + NSPersistentCloudKitContainer
Search index    GRDB.swift SQLite FTS5
EPUB unzip      ZIPFoundation
TTS             AVSpeechSynthesizer + MPRemoteCommandCenter
Networking      URLSession async/await only

SPM:
https://github.com/weichsel/ZIPFoundation.git  from: “0.9.0”
https://github.com/groue/GRDB.swift.git        from: “7.0.0”

FILE_TREE:
EpubReader/
App/
AppEntry.swift            @main SwiftUI App
AppState.swift            ObservableObject global state
NavigationCoordinator.swift
Features/
Library/
LibraryView.swift
LibraryViewModel.swift
BookGridCell.swift
BookListCell.swift
BookDetailView.swift
ShelfView.swift
Reader/
ReaderView.swift
ReaderViewModel.swift
EPUBWebView.swift       UIViewRepresentable WKWebView
EPUBBridge.swift        WKScriptMessageHandler
PageController.swift
ReaderOverlay.swift
ReaderSettings.swift
Annotations/
HighlightManager.swift
NoteEditor.swift
BookmarkPanel.swift
AnnotationsSidebar.swift
AnnotationExporter.swift
TTS/
TTSController.swift
TTSBar.swift
TTSSettings.swift
Search/
LibrarySearchView.swift
InBookSearchView.swift
Settings/
SettingsView.swift
AppearanceSettings.swift
SyncSettings.swift
Integrations/
CalibreClient.swift
OPDSBrowser.swift
OPDSBrowserView.swift
KOReaderSync.swift
Core/
EPUB/
EPUBParser.swift
EPUBBook.swift
EPUBChapter.swift
CFIParser.swift
EPUBExtractor.swift
PDF/
PDFReader.swift
PDFAnnotationBridge.swift
Models/
Book.swift              NSManagedObject subclass
Annotation.swift
Bookmark.swift
ReadingProgress.swift
Shelf.swift
Persistence/
PersistenceController.swift
CloudKitSync.swift
MigrationManager.swift
Utilities/
FileImporter.swift
MetadataExtractor.swift
CoverImageExtractor.swift
Logger.swift            os.Logger wrapper
Resources/
epub.js                   pinned 0.3.93
jszip.min.js              required before epub.js
reader.html               WKWebView host page
reader.css                base reader stylesheet
Assets.xcassets
Tests/
EPUBParserTests.swift
CFIParserTests.swift
SyncTests.swift
AnnotationTests.swift

DATA_FLOW:
SwiftUI action → ViewModel → Core layer
→ EPUBBridge.callJS()  [Swift→JS]
→ epub.js
→ postMessage()    [JS→Swift]
→ Core Data → CloudKit

CORE_DATA_ENTITIES:
Book             id(UUID) title author filePath coverImagePath language description sha256 importedAt isDeleted deletedAt
Shelf            id(UUID) name order
ShelfMembership  bookID shelfID
ReadingProgress  id(UUID) bookID cfi percentage deviceID updatedAt
Highlight        id(UUID) bookID cfiRange cfiStart spineHref colorName selectedText noteText createdAt updatedAt
Bookmark         id(UUID) bookID cfi spineHref label createdAt
ReadingSession   id(UUID) bookID startedAt endedAt wordsRead

CONFLICT_RESOLUTION:
ReadingProgress  → most recent updatedAt wins
Highlight        → merge by cfiRange; both survive if different range
Bookmark         → union merge
Shelf            → union merge
Book deletion    → soft delete (isDeleted=true, deletedAt set); purge after 30 days

WKWEBVIEW_BRIDGE_PATTERN:
// JS → Swift
window.webkit.messageHandlers.bridge.postMessage({ type: “eventName”, …data })
// Swift → JS (fire-and-forget only)
webView.evaluateJavaScript(“functionName(arg)”)
// Swift → JS (with return value, iOS 14.5+)
let result = try await webView.callAsyncJavaScript(“return functionName()”, …)

EPUB_JS_KEY_APIS:
book   = ePub(arrayBuffer, { openAs:‘binary’ })
rendition = book.renderTo(‘viewer’, { flow:‘paginated’, spread:‘none’, width:W, height:H })
rendition.display(cfiOrHrefOrPercentage)
rendition.next() / rendition.prev()
rendition.on(‘relocated’, location => { location.start.cfi, location.start.percentage, location.atEnd })
rendition.on(‘selected’, (cfiRange, contents) => {})
rendition.themes.register(name, cssObject) / .select(name) / .fontSize(px) / .font(family)
rendition.hooks.content.register((contents) => {})
rendition.annotations.highlight(cfiRange, data, cb, className, style)
rendition.annotations.remove(cfiRange, type)
book.locations.generate(1024) → serialize with .save() / restore with .load()
book.spine.get(index).load().then(section => section.find(term))

DESIGN_TOKENS:
accent          #D97706 (warm amber)
reader_bg_light #FFFFF8
reader_bg_dark  #1C1C1E
library_bg_light #F2F2F7
library_bg_dark  #000000
cover_radius    6pt
cover_shadow    opacity:0.15 y:4pt blur:8pt
grid_spacing    4pt base (4,8,12,16,20,24,32,48)
page_curl       duration:0.35s spring:damping0.85

PERF_TARGETS:
epub_open        < 1.5s
page_turn        < 50ms
library_100books < 0.5s
in_book_search   < 1s
memory_reading   < 100MB
battery_1hr      < 5%

CFI_STORAGE_RULE:
Always store alongside CFI: spineHref + characterOffset(Int) + contextSnippet(20chars) + percentage(Double)
Reason: CFI resolution can fail on malformed EPUBs; fallbacks prevent data loss.

SAFE_AREA_RULE:
Rendition height = view.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom
Call rendition.resize(width, adjustedHeight) on every layout change and rotation.

LOCATIONS_CACHE_RULE:
After book.locations.generate(), serialize with book.locations.save() and store in Core Data on Book entity (field: locationsCache String).
On next open, call book.locations.load(cached) before display. Skip generate() if cache exists.

<!-- ============================================================
  TASKS
  Format per task:
    - [x/space] ID  TITLE
      TARGET   path/to/File.swift
      IMPL     what to build (precise, implementation-level)
      VERIFY   one concrete, checkable condition
============================================================ -->

## PHASE 0 — FOUNDATION

Goal: app launches, opens one EPUB, renders it, turns pages, shows progress.

- [x] 0.1  Create Xcode project
  TARGET   EpubReader.xcodeproj
  IMPL     New iOS App, SwiftUI lifecycle, Swift, bundle ID com.yourname.epubreader, iOS 17 deployment target, no CoreData checkbox (add manually), no tests checkbox (add manually). Add SPM packages: ZIPFoundation (weichsel/ZIPFoundation ≥0.9.0), GRDB.swift (groue/GRDB.swift ≥7.0.0).
  VERIFY   Project builds for simulator with zero errors.
- [x] 0.2  Create Logger utility
  TARGET   Core/Utilities/Logger.swift
  IMPL     Public singleton wrapping os.Logger with subsystem=Bundle.main.bundleIdentifier and category per call site. Methods: debug(), info(), error(). All other files use this; no print() anywhere in the codebase.
  VERIFY   File compiles. No print() calls anywhere in project.
- [x] 0.3  Vendor epub.js and jszip
  TARGET   Resources/jszip.min.js, Resources/epub.js
  IMPL     Download jszip 3.10.1 minified from https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js and epub.js 0.3.93 from https://github.com/futurepress/epub.js/releases/tag/v0.3.93 (use epub.js not epub.min.js for debuggability). Add both files to Xcode target. jszip MUST be listed before epub.js in reader.html script tags.
  VERIFY   Both files present in Resources/ and added to app target. File sizes: jszip >100KB, epub.js >200KB.
- [x] 0.4  Create reader.html
  TARGET   Resources/reader.html
  IMPL     Minimal HTML page that: (1) loads jszip.min.js then epub.js in <head>, (2) has <div id="viewer"> filling full viewport with overflow hidden, (3) defines window.bridge = { send: (type, data) => window.webkit.messageHandlers.bridge.postMessage({type,…data}) }, (4) defines async loadBook(base64) which calls ePub(base64,{encoding:‘base64’}), then book.renderTo(‘viewer’,{flow:‘paginated’,spread:‘none’,minSpreadWidth:9999,width:window.innerWidth,height:window.innerHeight}), attaches relocated/selected/markClicked events that call bridge.send(), then calls rendition.display() and after ready calls bridge.send(‘bookReady’,{}), (5) defines nextPage(), prevPage(), displayCFI(cfi), resizeRendition(w,h) as globals callable from Swift.
  VERIFY   File is valid HTML. Script tags reference correct filenames. No inline event handlers.
- [x] 0.5  Create reader.css
  TARGET   Resources/reader.css
  IMPL     Base CSS injected into epub.js iframe content via rendition.themes. Defines: body{margin:0;padding:20px 24px;box-sizing:border-box} p{margin:0 0 1em 0;} img{max-width:100%;} a{color:inherit;} ::selection{background:#FEF08A;} Classes: .tts-highlight{background:rgba(254,240,138,0.6);border-radius:2px;} .hl-yellow{background:rgba(254,240,138,0.45);} .hl-green{background:rgba(187,247,208,0.45);} .hl-blue{background:rgba(191,219,254,0.45);} .hl-pink{background:rgba(251,207,232,0.45);} .hl-orange{background:rgba(253,215,170,0.45);}
  VERIFY   Valid CSS. All five highlight color classes present.
- [x] 0.6  Implement EPUBExtractor
  TARGET   Core/EPUB/EPUBExtractor.swift
  IMPL     Actor EPUBExtractor. Single method: func extract(_ url: URL) async throws -> URL. Unzips .epub using ZIPFoundation Archive into FileManager.default.temporaryDirectory / UUID().uuidString. Returns the extracted root directory URL. On failure throws EPUBError.extractionFailed. Cleans up temp dir if extraction fails midway.
  VERIFY   Unit test: extract a real .epub → returned URL exists on disk, contains META-INF/container.xml.
- [x] 0.7  Implement EPUBParser
  TARGET   Core/EPUB/EPUBParser.swift, Core/EPUB/EPUBBook.swift, Core/EPUB/EPUBChapter.swift
  IMPL     EPUBBook: struct with title(String) author(String) language(String) identifier(String) spineItems([EPUBChapter]) manifestItems([EPUBManifestItem]) coverImagePath(URL?). EPUBChapter: struct id(String) href(URL) mediaType(String) label(String) subChapters([EPUBChapter]). EPUBParser: actor with func parse(extractedRoot: URL) async throws -> EPUBBook. Parse META-INF/container.xml with XMLParser → find OPF full-path. Parse OPF: extract <metadata> dc:title/dc:creator/dc:language/dc:identifier, build manifest dict keyed by id, build spine array of EPUBChapter in order. For TOC: prefer EPUB3 nav document (manifest item with properties=“nav”) parsed for <nav epub:type="toc"> hierarchy; fall back to NCX toc.ncx. Cover: check manifest for properties=“cover-image” → if not found check <meta name="cover" content="id"> → resolve to absolute URL from OPF directory.
  VERIFY   Unit test: parse Moby Dick from Standard Ebooks → title=“Moby Dick”, author contains “Melville”, spineItems.count > 100.
- [x] 0.8  Implement LeakAvoider and EPUBBridge
  TARGET   Core/Utilities/LeakAvoider.swift, Features/Reader/EPUBBridge.swift
  IMPL     LeakAvoider: final class, weak var delegate: WKScriptMessageHandler?, conforms to WKScriptMessageHandler, forwards didReceive to delegate. EPUBBridge: @MainActor final class, holds weak var webView: WKWebView?. func setup() -> WKWebViewConfiguration: creates WKWebViewConfiguration, creates WKUserContentController, adds LeakAvoider(delegate:self) for name “bridge”, sets allowFileAccessFromFileURLs preference, returns config. Conforms to WKScriptMessageHandler. switch on message body[“type”]: “relocated”→onRelocated(cfi:String,pct:Double), “bookReady”→onBookReady(), “selected”→onSelected(cfiRange:String,text:String), “markClicked”→onMarkClicked(id:String), “requestHighlights”→onRequestHighlights(spineHref:String), “chapterLoaded”→onChapterLoaded(). func callJS(_ js: String): calls webView?.evaluateJavaScript(js). deinit: removes “bridge” handler. Callbacks as var closures.
  VERIFY   No retain cycle: EPUBBridge does not strongly hold WKWebView. LeakAvoider.delegate is weak.
- [ ] 0.9  Implement EPUBWebView
  TARGET   Features/Reader/EPUBWebView.swift
  IMPL     struct EPUBWebView: UIViewRepresentable. @Binding var bridge: EPUBBridge. makeUIView: create WKWebView with bridge.setup() config, disable scrollView.isScrollEnabled, bounces=false, min/maxZoomScale=1.0, load reader.html with loadFileURL allowingReadAccessTo Resources/ directory. updateUIView: no-op. makeCoordinator returns Coordinator which owns bridge callbacks forwarded to SwiftUI via bindings. Exposes: func loadBook(base64: String) { bridge.callJS(“loadBook(’(base64)’)”) }. func nextPage() { bridge.callJS(“nextPage()”) }. func prevPage() { bridge.callJS(“prevPage()”) }.
  VERIFY   Instantiated in a SwiftUI preview without crashing.
- [ ] 0.10  Implement FileImporter and ReaderView
  TARGET   Core/Utilities/FileImporter.swift, Features/Reader/ReaderView.swift, Features/Reader/ReaderViewModel.swift
  IMPL     FileImporter: struct with func importEPUB() presenting UIDocumentPickerViewController for UTType.epub. On pick: calls EPUBExtractor.extract() then EPUBParser.parse() then loads data(contentsOf:) and base64Encodes, returns (EPUBBook, base64String). ReaderViewModel: @MainActor ObservableObject. @Published var book: EPUBBook?, isLoading: Bool, currentCFI: String = “”, percentage: Double = 0. Exposes loadFromFile(). ReaderView: SwiftUI view containing EPUBWebView + minimal overlay (shown/hidden on tap): back chevron, chapter title (book.spineItems[currentSpineIndex].label), progress label “(Int(percentage*100))%”, prev/next buttons. On appear with a book: calls loadBook(base64). Wire bridge callbacks: onRelocated → update currentCFI and percentage.
  VERIFY   Manually open a .epub from Files app. Book text renders. Tap next/prev buttons → pages turn. Progress percentage updates.

PHASE_0_MILESTONE: Open an EPUB from Files. Renders. Pages turn. Percentage shows. Zero crashes on 3 different EPUBs.

## PHASE 1 — LIBRARY

Goal: real library screen, cover extraction, shelves, Core Data schema.

- [ ] 1.1  Define Core Data model
  TARGET   EpubReader.xcdatamodeld
  IMPL     Create via File→New in Xcode. Entities and attributes as listed in ARCH CORE_DATA_ENTITIES. All UUID attributes: type UUID. All String attributes: type String, optional where noted. Relationships: Book↔Shelf via ShelfMembership (many-to-many). ReadingProgress→Book (one-to-one by bookID, not a CD relationship, store UUID manually for CloudKit compatibility). Generate NSManagedObject subclasses for all entities. Set Module to “Current Product Module”.
  VERIFY   Model compiles. NSManagedObject subclasses visible to Swift.
- [ ] 1.2  Implement PersistenceController
  TARGET   Core/Persistence/PersistenceController.swift
  IMPL     @MainActor final class PersistenceController. static let shared. lazy var container: NSPersistentContainer (not CloudKit yet — added in 6a.1). var viewContext: NSManagedObjectContext { container.viewContext }. func backgroundContext() -> NSManagedObjectContext: newBackgroundContext with mergePolicy=NSMergeByPropertyObjectTrumpMergePolicy. viewContext.automaticallyMergesChangesFromParent = true. In DEBUG: seed with one test Book pointing to a bundled test.epub if library is empty.
  VERIFY   App launches, PersistenceController.shared does not crash, viewContext accessible.
- [ ] 1.3  Implement MetadataExtractor
  TARGET   Core/Utilities/MetadataExtractor.swift
  IMPL     Actor MetadataExtractor. func extract(from book: EPUBBook) -> BookMetadata. BookMetadata: struct mirroring Book entity fields (title, author, language, description, identifier). Pulls from EPUBBook already parsed — this is a mapping layer, no additional file I/O. Also computes sha256: Data of epub file → SHA256Digest via CryptoKit.SHA256.hash() → hex string.
  VERIFY   Called on a parsed EPUBBook returns non-empty title and valid sha256 hex string (64 chars).
- [ ] 1.4  Implement CoverImageExtractor
  TARGET   Core/Utilities/CoverImageExtractor.swift
  IMPL     Actor CoverImageExtractor. func extract(from book: EPUBBook, extractedRoot: URL) async throws -> URL?. Priority: (1) manifest item with properties containing “cover-image” → load → return JPEG path. (2) OPF meta name=“cover” → resolve id → load. (3) First img src in first spine item HTML (parse with XMLParser or regex). On success: resize to max 400x600 using UIGraphicsImageRenderer, write JPEG quality 0.85 to Application Support/covers/{sha256}.jpg. Return URL of written file.
  VERIFY   Running on a Standard Ebooks EPUB returns a non-nil URL pointing to a file that UIImage can load.
- [ ] 1.5  Upgrade FileImporter with deduplication and progress
  TARGET   Core/Utilities/FileImporter.swift (update)
  IMPL     Update importEPUB to support multi-file selection (UIDocumentPickerViewController allowsMultipleSelection=true). For each file: compute sha256 first, check Core Data for existing Book with same sha256, skip if exists. Run extract+parse+coverExtract+metadataExtract on backgroundContext. Create Book NSManagedObject, populate all fields, save backgroundContext. Report progress via AsyncStream<ImportProgress> where ImportProgress = enum processing(filename)/done(Book)/skipped(filename)/failed(filename,Error).
  VERIFY   Import same EPUB twice → only one Book in Core Data. Import 5 books → all 5 appear.
- [ ] 1.6  Build LibraryView and LibraryViewModel
  TARGET   Features/Library/LibraryView.swift, Features/Library/LibraryViewModel.swift
  IMPL     LibraryViewModel: @MainActor ObservableObject. @FetchRequest or NSFetchedResultsController on Book entity sorted by importedAt desc. @Published var displayMode: DisplayMode (grid/list), sortOrder: SortOrder (title/author/lastRead/dateAdded), searchQuery: String. LibraryView: NavigationStack root. Toolbar: sort menu, display mode toggle, import button. Body: if books.isEmpty show empty state illustration + “Import your first book” text + import button. Else: switch on displayMode → LazyVGrid (2 cols iPhone, 4 cols iPad) or List. Filter by searchQuery against title+author.
  VERIFY   Library with 10 books shows grid. Toggle to list → shows list. Sort by title → alphabetical order.
- [ ] 1.7  Build BookGridCell and BookListCell
  TARGET   Features/Library/BookGridCell.swift, Features/Library/BookListCell.swift
  IMPL     BookGridCell: VStack. Cover image: AsyncImage loading from book.coverImagePath (local file URL), placeholder is a colored rectangle derived from title hash. Corner radius 6pt. Shadow per DESIGN_TOKENS. Progress ring (ZStack overlay bottom-right): Circle stroke 2pt, progress = book.readingProgress?.percentage ?? 0, color=accent if in-progress, green if 100%. Title (font .caption weight .medium, lineLimit 2). Author (font .caption2, foregroundStyle .secondary). BookListCell: HStack. Small cover thumbnail 50×70pt. VStack with title+author+progress percentage text. Chevron trailing.
  VERIFY   GridCell renders with cover image, progress ring at 23%, title/author visible.
- [ ] 1.8  Build ShelfView and context menus
  TARGET   Features/Library/ShelfView.swift (update LibraryView.swift)
  IMPL     ShelfView: horizontal ScrollView of shelf tabs. Tapping a shelf filters LibraryView to that shelf’s books. “All Books” always first. Add shelf button opens an alert for shelf name entry → creates Shelf entity. Long-press a book cell anywhere in LibraryView → contextMenu with: “Add to Shelf” (submenu of shelf names), “Mark as Finished”, “Delete from Library” (destructive, with confirmation), “Edit Metadata” (opens BookDetailView in edit mode).
  VERIFY   Create shelf “Favorites”. Long-press book → Add to Shelf → Favorites. Filter by Favorites → only that book shows.
- [ ] 1.9  Build BookDetailView
  TARGET   Features/Library/BookDetailView.swift
  IMPL     Sheet presented on book tap. Cover image (large, 120×180pt). Title (largeTitle). Author, language, description, file size, format badge. “Continue Reading”/“Start Reading” button (full width, accent fill) → dismisses sheet and navigates to ReaderView with this book. Progress bar showing percentage. Import date. If in edit mode (from context menu): title and author are TextFields. Save button commits changes to Core Data.
  VERIFY   Tap book → detail sheet appears. Tap “Start Reading” → ReaderView opens with that book’s content.

PHASE_1_MILESTONE: Import 10 books. All show covers. Shelves work. Tap book → reader opens. Sort and filter work.

## PHASE 2a — PAGINATION

Goal: page turns feel like Apple Books. CFI saves and restores correctly.

- [ ] 2a.1  Implement PageController
  TARGET   Features/Reader/PageController.swift
  IMPL     @MainActor final class PageController: ObservableObject. @Published currentCFI: String, percentageInBook: Double, currentSpineIndex: Int. func onRelocated(cfi: String, pct: Double, atEnd: Bool): update published props, trigger CFI save (debounced 500ms via Task.sleep). func saveCFI(for bookID: UUID) async: upsert ReadingProgress in Core Data backgroundContext. func restoreCFI(for bookID: UUID) async -> String?: fetch ReadingProgress, return cfi or nil.
  VERIFY   After simulating onRelocated, Core Data contains ReadingProgress with matching cfi.
- [ ] 2a.2  Configure paginated rendition in reader.html
  TARGET   Resources/reader.html (update)
  IMPL     In loadBook(): set rendition options flow:‘paginated’, spread:‘none’, minSpreadWidth:9999. After rendition created: rendition.on(‘relocated’, loc => { bridge.send(‘relocated’,{cfi:loc.start.cfi, percentage:loc.start.percentage, atEnd:loc.atEnd}) }). Expose resizeRendition(w,h) = rendition.resize(w,h). Expose displayCFI(cfi) = rendition.display(cfi). On relocated, also call: if(loc.atEnd) bridge.send(‘atChapterEnd’,{}).
  VERIFY   After loadBook() call from Swift, relocated event fires and bridge receives it.
- [ ] 2a.3  Disable WKWebView native scroll and zoom
  TARGET   Features/Reader/EPUBWebView.swift (update)
  IMPL     In makeUIView: webView.scrollView.isScrollEnabled = false. webView.scrollView.bounces = false. webView.scrollView.minimumZoomScale = 1.0. webView.scrollView.maximumZoomScale = 1.0. Also inject viewport meta tag via WKUserScript at documentStart: “var m=document.createElement(‘meta’);m.name=‘viewport’;m.content=‘width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no’;document.head.appendChild(m);”
  VERIFY   Pinch gesture on reader does not zoom. Scroll gesture does not scroll the page.
- [ ] 2a.4  Implement swipe gesture handling
  TARGET   Features/Reader/ReaderView.swift (update)
  IMPL     Add DragGesture in ReaderView with minimumDistance 30. On gesture end: if translation.width < -50 call bridge.callJS(“nextPage()”). If translation.width > 50 call bridge.callJS(“prevPage()”). Also add tap gesture (single tap on left 25% of screen → prev, right 25% → next, center → toggle overlay). Ensure gesture does not block text selection.
  VERIFY   Swipe left → next page. Swipe right → prev page. Tap left/right edges → page turns.
- [ ] 2a.5  Implement page-curl animation
  TARGET   Features/Reader/ReaderView.swift (update)
  IMPL     Replace the plain EPUBWebView embed with a UIPageViewController (style: .pageCurl, orientation: .horizontal) wrapped via UIViewControllerRepresentable. The page VC manages current and adjacent view controllers each hosting one EPUBWebView from a pool of 3. When dataSource asks for before/after VCs, return pooled WKWebView instances. The page content is the same rendition — Swift controls which rendition.display() is called. On atChapterEnd: pre-display next chapter in the adjacent pooled WKWebView before user reaches it.
  VERIFY   Page turn shows curl animation. Reversing the curl shows previous page correctly.
- [ ] 2a.6  CFI save and restore wired end-to-end
  TARGET   Features/Reader/ReaderViewModel.swift (update), Features/Reader/ReaderView.swift (update)
  IMPL     On ReaderView.onAppear(book): call pageController.restoreCFI(for:book.id) → if non-nil, after bookReady event fires call bridge.callJS(“displayCFI(’(cfi)’)”). On every onRelocated callback: call pageController.onRelocated(cfi:pct:atEnd:). Debounce write: after 500ms with no new relocation, write to Core Data.
  VERIFY   Read to page 20. Force-quit. Relaunch. Book reopens at page 20.
- [ ] 2a.7  Safe area and rotation handling
  TARGET   Features/Reader/EPUBWebView.swift (update)
  IMPL     Store currentSize: CGSize. In updateUIView: if newSize != currentSize { currentSize = newSize; let adjH = newSize.height - safeAreaInsets.bottom; bridge.callJS(“resizeRendition((newSize.width), (adjH))”) }. Also call resize on UIDevice.orientationDidChangeNotification. Ensure safeAreaInsets read from the UIView not the window.
  VERIFY   Rotate device. Text reflows correctly. No clipping at bottom on device with home bar.

PHASE_2a_MILESTONE: Open book, read 15 pages, quit. Reopen → resumes at page 15. Rotation works. Curl animation plays.

## PHASE 2b — APPEARANCE

Goal: font, theme, margins, line spacing all configurable and live-updating.

- [ ] 2b.1  Define ReaderAppearance model
  TARGET   Features/Reader/ReaderSettings.swift
  IMPL     @Observable class ReaderAppearance (or ObservableObject). All properties backed by @AppStorage: fontFamily(String=“Literata”), fontSize(Double=18), theme(String=“light”), lineSpacing(Double=1.5), marginStyle(String=“normal”), textAlignment(String=“justify”), hyphenation(Bool=true). Expose computed cssVariables: [String:String] dict mapping each setting to its CSS value. Expose func applyAll(via bridge: EPUBBridge) calling all inject methods.
  VERIFY   Change fontSize via code → @AppStorage persists across app restarts.
- [ ] 2b.2  Bundle reader fonts
  TARGET   Resources/Fonts/ (Literata-Regular.ttf, Literata-Italic.ttf, EBGaramond-Regular.ttf, EBGaramond-Italic.ttf, iAWriterQuattroS-Regular.ttf, iAWriterQuattroS-Italic.ttf)
  IMPL     Download OFL-licensed fonts: Literata from Google Fonts, EB Garamond from Google Fonts, iA Writer Quattro S from github.com/iaolo/iA-Fonts. Add to Xcode target and Info.plist UIAppFonts array. Note: Charter is a system font, no file needed.
  VERIFY   UIFont(name:“Literata-Regular”,size:18) returns non-nil.
- [ ] 2b.3  Implement theme injection
  TARGET   Features/Reader/EPUBBridge.swift (update), Resources/reader.html (update)
  IMPL     In reader.html: after rendition created, call rendition.themes.register for each theme: light={body:{background:’#FFFFF8’,color:’#1C1C1E’}}, dark={body:{background:’#1C1C1E’,color:’#E5E5EA’}}, sepia={body:{background:’#F4ECD8’,color:’#3B2F2F’}}. Expose global setTheme(name). In EPUBBridge: func applyTheme(_ theme: String) = callJS(“setTheme(’(theme)’)”). Call on appearance change.
  VERIFY   Switch to dark theme in settings → reader background immediately turns dark.
- [ ] 2b.4  Implement font, size, spacing injection
  TARGET   Features/Reader/EPUBBridge.swift (update), Resources/reader.html (update)
  IMPL     Expose in reader.html: setFontSize(px:Int), setFontFamily(name:String), setLineSpacing(value:Float), setMargin(px:Int), setJustify(justify:Bool), setHyphenation(on:Bool). Each calls rendition.themes.override with appropriate CSS. EPUBBridge: corresponding Swift functions calling callJS(). After any appearance change, call rendition.resize(w,h) to trigger reflow and update page count.
  VERIFY   Change font size slider → text immediately reflows to new size. Page count updates.
- [ ] 2b.5  Build AppearanceSettings view
  TARGET   Features/Settings/AppearanceSettings.swift
  IMPL     View presented as .sheet with .presentationDetents([.medium, .large]). Sections: (1) Font size: stepper + label showing current size. (2) Font family: horizontal ScrollView of font name buttons, each rendering “Aa” in that font; selected has accent border. (3) Theme: 4 color swatches (light/dark/sepia/custom placeholder). (4) Margins: segmented control Narrow/Normal/Wide. (5) Line spacing: slider 1.2–2.0. (6) Toggles: Justify text, Hyphenation. All changes apply instantly via ReaderAppearance model which fires to EPUBBridge. No “Save” button needed.
  VERIFY   Open settings. Change font → reader updates behind the sheet. Close sheet. Settings persisted on relaunch.
- [ ] 2b.6  Per-book appearance override scaffold
  TARGET   Core/Models/Book.swift (update)
  IMPL     Add optional JSON field `appearanceOverride: String?` to Book entity. Add computed property func appearanceSettings() -> ReaderAppearance? decoding from JSON. Add func saveAppearanceOverride(_ appearance: ReaderAppearance). Wire: if book has override, use it instead of global settings when opening ReaderView. UI: long-press in AppearanceSettings → “Save as default for this book” option.
  VERIFY   Set custom font for one book. Open another book → different font. Return to first book → custom font restored.
- [ ] 2b.7  Locations cache save after appearance changes
  TARGET   Features/Reader/ReaderViewModel.swift (update)
  IMPL     After any appearance change triggers reflow: invalidate cached page count (it changes with font size). Do NOT invalidate the saved CFI — CFIs are position-stable across reflows. After reflow completes (next relocated event), re-query total pages from JS and update PageController. Serialize locations if they change: call book.locations.save() → store in Book.locationsCache via backgroundContext.
  VERIFY   Change font size → progress percentage stays accurate (doesn’t jump to wrong position).

PHASE_2b_MILESTONE: Change font to EB Garamond size 22 sepia. Reader updates instantly. Quit. Relaunch → settings persist.

## PHASE 2c — OVERLAYS AND NAVIGATION

Goal: TOC, scrubber, time estimate, chapter navigation.

- [ ] 2c.1  Build ReaderOverlay
  TARGET   Features/Reader/ReaderOverlay.swift
  IMPL     ZStack over the reader. Top bar: HStack with back button (chevron.left + “Library”), Spacer, chapter title (lineLimit 1), Spacer, HStack of icon buttons (magnifyingglass, list.bullet, gearshape). Bottom bar: HStack with text.book icon, Spacer, progress text “X% · ~Nm left”, Spacer, speaker.wave icon. Both bars use .ultraThinMaterial background with safe area padding. Visibility controlled by @State isVisible. Single tap anywhere in the reader (not on a button or text) toggles isVisible. Auto-hide: set a Timer for 3s after show; cancel timer on hide or interaction. All transitions: .opacity with .easeInOut(duration:0.2).
  VERIFY   Single tap → overlay appears. Wait 3 seconds → fades out. Tap again → reappears.
- [ ] 2c.2  Build TOCPanel
  TARGET   Features/Reader/TOCPanel.swift
  IMPL     Slide-in from leading edge as a .sheet or custom overlay. List of EPUBChapter items. Chapters with subChapters use DisclosureGroup. Current chapter highlighted with accent color background. Tap any chapter: call bridge.callJS(“displayCFI(’(chapter.href)’)”) and dismiss panel. Chapter label truncated to 2 lines.
  VERIFY   Open TOC. Tap chapter 5. Reader jumps to chapter 5. Current chapter highlighted in TOC.
- [ ] 2c.3  Build progress scrubber
  TARGET   Features/Reader/ReaderView.swift (update)
  IMPL     Capsule at very bottom of screen (above home indicator, below bottom bar). Height 4pt. Tap/drag: compute percentage from gesture x position / frame.width, call bridge.callJS(“displayCFI((pct))”). While dragging: show floating tooltip above thumb with chapter name at that percentage (resolve via book.spine lookup). Scrubber is always visible (not gated on overlay visibility).
  VERIFY   Drag scrubber to 50% → book jumps to midpoint. Tooltip shows chapter name.
- [ ] 2c.4  Reading time estimate
  TARGET   Features/Reader/ReaderViewModel.swift (update)
  IMPL     On bookReady: extract text from first 2 spine items via JS (book.spine.get(0).load().then(s=>s.document.body.innerText)) → estimate average words per chapter. Assume 238 WPM reading speed. Compute minutesRemainingInChapter = (wordsInCurrentChapter - wordsRead) / 238. Update on every onRelocated. Store estimated WPM per book in UserDefaults keyed by book sha256 for personalization in future.
  VERIFY   Overlay shows “~8m left” or similar for a normal-length chapter.
- [ ] 2c.5  Go-to-location and footnote intercept
  TARGET   Features/Reader/ReaderView.swift (update), Resources/reader.html (update)
  IMPL     Go-to-location: button in overlay → sheet with Slider 0–100 and TextField for percentage, “Go” button → bridge.callJS(“displayCFI((pct/100))”). Footnote intercept: in reader.html hooks.content, find all <a epub:type="noteref"> links, add click listener that instead of navigating calls bridge.send(‘footnoteRequest’,{href:href,text:title}); Swift shows the footnote text in a small popover sheet rather than navigating away.
  VERIFY   Tap a footnote → small sheet appears with footnote text. Dismiss → stays on current page.

PHASE_2c_MILESTONE: Tap screen → overlay. TOC slides in. Drag scrubber. Time estimate shows. Footnote taps open popover.

## PHASE 3a — HIGHLIGHTS

Goal: select text, highlight in 5 colors, persists across sessions.

- [ ] 3a.1  Add Highlight entity and HighlightManager
  TARGET   EpubReader.xcdatamodeld (update), Features/Annotations/HighlightManager.swift
  IMPL     Highlight entity already in model from 1.1. HighlightManager: @MainActor final class. func create(cfiRange: String, cfiStart: String, spineHref: String, color: HighlightColor, text: String, bookID: UUID) async. func fetchForChapter(spineHref: String, bookID: UUID) async -> [Highlight]. func delete(id: UUID) async. func updateColor(id: UUID, color: HighlightColor) async. All writes on backgroundContext. HighlightColor: enum yellow/green/blue/pink/orange with cssClass: String computed property matching reader.css classes.
  VERIFY   Create a highlight in Core Data, fetch by spineHref → returns it. Delete → no longer returned.
- [ ] 3a.2  Text selection → context menu
  TARGET   Resources/reader.html (update), Features/Reader/EPUBBridge.swift (update)
  IMPL     In reader.html: rendition.on(‘selected’, (cfiRange, contents) => { const text = contents.window.getSelection().toString().trim(); if(text.length < 2) return; const rect = contents.window.getSelection().getRangeAt(0).getBoundingClientRect(); bridge.send(‘textSelected’,{cfiRange, text, x:rect.x, y:rect.y, width:rect.width, height:rect.height}); }). In EPUBBridge onSelected: convert rect from WebView coords to SwiftUI coords. In ReaderView: show UIMenu at converted position with actions: Highlight (×5 colors), Copy, Look Up, Translate.
  VERIFY   Select a word → menu appears near selection with color options. Copy → pasteboard has the text.
- [ ] 3a.3  Create highlight in JS and Core Data
  TARGET   Features/Reader/ReaderViewModel.swift (update), Resources/reader.html (update)
  IMPL     In reader.html expose: addHighlight(cfiRange, colorClass) = rendition.annotations.highlight(cfiRange, {}, (e)=>bridge.send(‘markClicked’,{id:e.target.dataset.id}), colorClass, {}). removeHighlight(cfiRange) = rendition.annotations.remove(cfiRange,‘highlight’). When user picks a color from the context menu: call HighlightManager.create() → on success call bridge.callJS(“addHighlight(’(cfiRange)’,’(color.cssClass)’)”)
  VERIFY   Select text, tap yellow highlight → text turns yellow immediately.
- [ ] 3a.4  Restore highlights on chapter load
  TARGET   Resources/reader.html (update), Features/Reader/EPUBBridge.swift (update)
  IMPL     In reader.html hooks.content.register: after chapter HTML loaded, bridge.send(‘requestHighlights’, {spineHref: contents.cfiBase}). Wait for reply. Expose applyHighlights(json) = JSON.parse(json).forEach(h=>addHighlight(h.cfiRange, h.colorClass)). In EPUBBridge onRequestHighlights: fetch from HighlightManager, encode to JSON string, call bridge.callJS(“applyHighlights(’(escapedJSON)’)”).
  VERIFY   Create highlight. Navigate away to another chapter. Return → highlight still visible.
- [ ] 3a.5  Highlight tap action sheet
  TARGET   Features/Reader/ReaderView.swift (update)
  IMPL     onMarkClicked(id): show confirmationDialog (not alert) with: “Edit Note” → opens NoteEditor (3b.2), “Change Color” → submenu of 5 colors, “Delete” (destructive) → HighlightManager.delete() + bridge.callJS(“removeHighlight(’(cfiRange)’)”), “Copy Text” → UIPasteboard.
  VERIFY   Tap existing highlight → sheet appears. Tap Delete → highlight disappears immediately and is gone after chapter reload.
- [ ] 3a.6  Highlight color change
  TARGET   Features/Annotations/HighlightManager.swift (update)
  IMPL     func updateColor(id: UUID, newColor: HighlightColor) async: fetch Highlight by id, get cfiRange, update colorName in Core Data on backgroundContext. In ReaderView: on color change picked → HighlightManager.updateColor() → bridge.callJS(“removeHighlight(’(cfiRange)’)”) → bridge.callJS(“addHighlight(’(cfiRange)’,’(newColor.cssClass)’)”).
  VERIFY   Tap highlight → change color from yellow to blue → highlight turns blue. Reload chapter → still blue.

PHASE_3a_MILESTONE: Select sentence → highlight yellow → persist → close → reopen → still highlighted. Tap → action sheet. Delete → gone.

## PHASE 3b — NOTES, BOOKMARKS, EXPORT

Goal: notes on highlights, bookmarks, combined sidebar, Markdown export.

- [ ] 3b.1  Note field on Highlight + NoteEditor
  TARGET   Features/Annotations/NoteEditor.swift
  IMPL     Highlight entity already has noteText String? from 1.1. NoteEditor: sheet with TextEditor (minHeight 120pt), placeholder “Add a note…” (overlaid Text if empty), word count label, Done button that saves to Core Data. Presented from highlight action sheet “Edit Note” and from AnnotationsSidebar. Auto-focus TextEditor on appear.
  VERIFY   Add note to highlight. Dismiss. Note persists. Edit note → previous text pre-filled.
- [ ] 3b.2  Implement BookmarkPanel
  TARGET   Features/Annotations/BookmarkPanel.swift
  IMPL     Trailing-edge slide-in sheet. List of Bookmarks for current book sorted by createdAt. Each row: bookmark icon, label, chapter name. Tap → bridge.callJS(“displayCFI(’(bookmark.cfi)’)”) and dismiss. Swipe to delete. “Add Bookmark” button in sheet toolbar: creates Bookmark with current PageController.currentCFI, spineHref, auto-label = “[ChapterTitle] p.[page]”. Haptic on add.
  VERIFY   Tap add bookmark → appears in list. Tap it → jumps to that position. Swipe to delete → gone.
- [ ] 3b.3  Build AnnotationsSidebar
  TARGET   Features/Annotations/AnnotationsSidebar.swift
  IMPL     Full-height sheet. Segmented control top: Highlights | Notes | Bookmarks. Highlights tab: list grouped by spineHref (section header = chapter label). Each row shows: color swatch, truncated selectedText, note preview if exists. Notes tab: same but only highlights WITH notes, showing noteText. Bookmarks tab: flat list with chapter name + label. Tap any row → navigate to CFI and dismiss sheet. Search bar filters across active tab. Swipe to delete.
  VERIFY   Sidebar shows highlights grouped by chapter. Tap one → reader jumps to it.
- [ ] 3b.4  Implement AnnotationExporter
  TARGET   Features/Annotations/AnnotationExporter.swift
  IMPL     func exportMarkdown(book: Book, context: NSManagedObjectContext) async -> String. Output format: “# [Title]\nby [Author]\n\n—\n\n” then per chapter: “## [Chapter Label]\n\n” then per highlight in CFI order: “> [selectedText]\n” + if noteText: “[noteText]\n” + “\n”. func exportPlainText: same without markdown syntax. Return as String. Present via ShareLink(item: exportedString, subject: “(book.title) — Annotations”).
  VERIFY   Book with 3 highlights across 2 chapters exports correct Markdown structure.
- [ ] 3b.5  Look Up and Wikipedia from selection menu
  TARGET   Features/Reader/ReaderView.swift (update)
  IMPL     “Look Up” in selection menu: present UIReferenceLibraryViewController(term: selectedText) if UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm:) else open “https://www.google.com/search?q=(encoded)” in SafariServices. “Wikipedia” option: call https://en.wikipedia.org/api/rest_v1/page/summary/{encodedTerm} via URLSession, decode title+extract+thumbnail, show in a half-sheet with title/summary/thumbnail and “Open in Wikipedia” link.
  VERIFY   Select a word → Look Up → definition shows. Wikipedia → summary sheet appears.
- [ ] 3b.6  Share sheet and annotation export in toolbar
  TARGET   Features/Reader/ReaderOverlay.swift (update), Features/Library/BookDetailView.swift (update)
  IMPL     Share icon in reader overlay toolbar → ShareLink(item: selectedTextOrCurrentPageText). In BookDetailView (also accessible from library context menu): “Export Annotations” button → calls AnnotationExporter.exportMarkdown() → ShareLink. Add “Export All Annotations” as menu item in AnnotationsSidebar.
  VERIFY   Tap share in reader → iOS share sheet appears. Export annotations → Markdown file shared with correct content.

PHASE_3b_MILESTONE: Full annotation workflow. Highlight + note + bookmark + export all work.
~GATE_1_TESTFLIGHT_ALPHA~ READY AFTER THIS TASK.

## PHASE 4a — TTS CORE

Goal: book reads aloud, current sentence highlighted.

- [ ] 4a.1  Implement TTSController core
  TARGET   Features/TTS/TTSController.swift
  IMPL     @MainActor final class TTSController: NSObject, AVSpeechSynthesizerDelegate, ObservableObject. @Published isPlaying: Bool, currentSentenceCFI: String?, currentVoice: AVSpeechSynthesisVoice?. Private synthesizer: AVSpeechSynthesizer. Private sentenceQueue: [(text: String, cfi: String)]. func prepareChapter(spineHref: String, bridge: EPUBBridge) async: extract plain text from JS (call bridge, await response with chapter innerText), tokenize into sentences using NLTokenizer(.sentence), build sentenceQueue by pairing each sentence to a CFI via book.locations. func play(), pause(), stop(), nextSentence(), prevSentence(). AVSpeechSynthesizerDelegate: speechSynthesizer(_:didFinish:) → advance to next sentence.
  VERIFY   prepareChapter() on a chapter → sentenceQueue has > 10 items. play() → AVSpeechSynthesizer speaks.
- [ ] 4a.2  Sentence-to-CFI mapping
  TARGET   Features/TTS/TTSController.swift (update), Resources/reader.html (update)
  IMPL     In reader.html expose: getChapterText(spineIndex) = async function returning {text: string, sentences: [{text, cfi}]}. Use book.spine.get(spineIndex), load it, then for each sentence in NLTokenizer output find its DOM position via book.locations or document.createTreeWalker and generate CFI. Bridge: onChapterTextReady callback. This is the hardest part — if full CFI per sentence is too slow, fall back to storing sentence index and using percentage-based seek.
  VERIFY   getChapterText(0) returns array with ≥ 10 sentences each with non-empty cfi.
- [ ] 4a.3  Sentence highlighting in WKWebView
  TARGET   Features/TTS/TTSController.swift (update), Resources/reader.html (update)
  IMPL     In reader.html expose: highlightSentence(cfi) — removes any existing element with id=“tts-current”, then adds highlight via rendition.annotations.mark(cfi, {id:‘tts-current’}, null, ‘tts-highlight’) using the tts-highlight CSS class. clearTTSHighlight() removes it. In TTSController delegate willSpeakRangeOfSpeechString: get current sentence cfi, call bridge.callJS(“highlightSentence(’(cfi)’)”). On didFinish utterance: advance sentenceQueue index, speak next, update highlight.
  VERIFY   TTS playing → one sentence highlighted at a time. Highlight moves with speech.
- [ ] 4a.4  Chapter auto-advance
  TARGET   Features/TTS/TTSController.swift (update)
  IMPL     On sentenceQueue exhausted (last sentence finished): get currentSpineIndex+1, call prepareChapter() for next chapter, call bridge.callJS(“nextPage()”) to advance reader visually, continue play(). If already at last chapter: stop().
  VERIFY   TTS reaches end of chapter 1 → automatically begins chapter 2 without user action.
- [ ] 4a.5  Build TTSBar
  TARGET   Features/TTS/TTSBar.swift
  IMPL     HStack with: prevSentence button (chevron.left), play/pause button (larger, filled), nextSentence button (chevron.right), speed label tappable (opens TTSSettings sheet), voice name label (truncated). Fixed height 52pt. Background: ultraThinMaterial. Bottom safe area padding. Slide in from bottom with spring animation when TTS starts. Disappear with easeOut when stopped.
  VERIFY   TTSBar appears on TTS start. Play/pause works. Prev/next sentence works.

PHASE_4a_MILESTONE: TTS reads chapter aloud. One sentence highlighted at a time. Reaches end of chapter → next chapter continues. TTSBar controls work.

## PHASE 4b — TTS PLATFORM

Goal: lock screen, AirPods, speed, voice picker, sleep timer.

- [ ] 4b.1  AVAudioSession and background audio
  TARGET   Features/TTS/TTSController.swift (update)
  IMPL     In play(): try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: .mixWithOthers); try AVAudioSession.sharedInstance().setActive(true). Add UIBackgroundModes “audio” to Info.plist. Verify TTS continues when screen locks.
  VERIFY   Start TTS. Lock screen. TTS continues playing audio.
- [ ] 4b.2  Now Playing info and lock screen controls
  TARGET   Features/TTS/TTSController.swift (update)
  IMPL     On play: set MPNowPlayingInfoCenter.default().nowPlayingInfo with MPMediaItemPropertyTitle=book.title, MPMediaItemPropertyArtist=book.author, MPMediaItemPropertyAlbumTitle=currentChapterLabel, MPMediaItemPropertyArtwork=MPMediaItemArtwork with cover UIImage, MPNowPlayingInfoPropertyElapsedPlaybackTime=elapsed, MPMediaItemPropertyPlaybackDuration=estimatedChapterDuration. Update on every sentence. MPRemoteCommandCenter: enable playCommand, pauseCommand, nextTrackCommand (→nextSentence), previousTrackCommand (→prevSentence).
  VERIFY   Lock screen shows book title, author, cover art, and control buttons. AirPods double-tap pauses.
- [ ] 4b.3  Build TTSSettings
  TARGET   Features/TTS/TTSSettings.swift
  IMPL     Sheet with: speed Slider 0.5×–3.0× in steps of 0.25 (map to AVSpeechUtteranceDefaultSpeechRate × multiplier); pitch Slider 0.8–1.2; voice Picker grouped by language using AVSpeechSynthesisVoice.speechVoices() sorted by quality (premium first). Preview button speaks “The quick brown fox” in selected voice. All settings persisted in UserDefaults.
  VERIFY   Set speed 2.0×. Close sheet. TTS plays at double speed. Set voice → speech uses new voice.
- [ ] 4b.4  Sleep timer
  TARGET   Features/TTS/TTSBar.swift (update), Features/TTS/TTSController.swift (update)
  IMPL     In TTSBar: long-press play button → menu with: Off, 10 min, 20 min, 30 min, End of Chapter. Timer stored in TTSController as Task. On expiry: pause() and save position. End of Chapter: set flag, on atChapterEnd event received pause(). Show remaining time in TTSBar (small label) when active.
  VERIFY   Set 10min timer. Wait. TTS pauses. Set End of Chapter → finishes current chapter then pauses.
- [ ] 4b.5  Page auto-scroll following TTS
  TARGET   Features/TTS/TTSController.swift (update)
  IMPL     On each sentence: compare currentSentenceCFI to PageController.currentCFI. If the sentence is on a different page (CFI comparison via epub.js epubCFI.compare()), call bridge.callJS(“nextPage()”) silently. Use EPUBCFICompare function: bridge.callJS(“window.epubCFI ? new ePub.CFI().compare(’(sentenceCFI)’,’(pageCFI)’) : 0”) and parse result.
  VERIFY   TTS reaches bottom of visible page → reader turns to next page automatically.

PHASE_4b_MILESTONE: Lock screen shows book cover + title. AirPods controls work. Speed at 1.5× works. Sleep timer fires.

## PHASE 5 — SEARCH

Goal: find text in book, search library, Spotlight.

- [ ] 5.1  In-book search
  TARGET   Features/Search/InBookSearchView.swift, Resources/reader.html (update)
  IMPL     In reader.html expose: searchBook(term) = async function that calls book.spine.find(term) (epub.js 0.3.93 method) returning [{cfi, excerpt}]. Bridge result via postMessage. InBookSearchView: sheet with SearchBar at top. On search: call bridge, display results in List (excerpt with term bolded, chapter name above each group). Tap result → rendition.display(cfi), highlight the match via rendition.annotations.mark(). Show result count. “No results” empty state.
  VERIFY   Search “whale” in Moby Dick → > 10 results. Tap result → jumps and highlights.
- [ ] 5.2  Library search with FTS5
  TARGET   Core/Persistence/PersistenceController.swift (update), Features/Library/LibrarySearchView.swift
  IMPL     On book import (FileImporter): insert into GRDB table book_fts (CREATE VIRTUAL TABLE book_fts USING fts5(id, title, author, description)). LibrarySearchView: shown when search is active in LibraryView. Queries GRDB: SELECT id FROM book_fts WHERE book_fts MATCH ? ORDER BY rank. Loads matching Books from Core Data by id. Shows same BookGridCell as library. Searches title+author+description.
  VERIFY   Import book “Moby Dick by Herman Melville”. Search “Melville” → book appears. Search “xyz123” → no results.
- [ ] 5.3  Annotation search
  TARGET   Features/Annotations/AnnotationsSidebar.swift (update)
  IMPL     SearchBar at top of AnnotationsSidebar. Filters currently active tab: for Highlights, predicate selectedText CONTAINS[cd] query OR noteText CONTAINS[cd] query; for Bookmarks, predicate label CONTAINS[cd] query. Results update live. Clear search → all items return.
  VERIFY   Search “captain” in annotations → only highlights containing “captain” shown.
- [ ] 5.4  Spotlight indexing
  TARGET   Core/Utilities/FileImporter.swift (update)
  IMPL     After book saved to Core Data: create CSSearchableItem with CSSearchableItemAttributeSet(contentType:.text). Set title, contentDescription (book description truncated 300 chars), thumbnailData (cover JPEG data). Add to CSSearchableIndex.default(). On book delete: CSSearchableIndex.default().deleteSearchableItems(withIdentifiers:[bookID.uuidString]). In @main App: onContinueUserActivity check activityType == CSSearchableItemActionType → extract id → navigate to book.
  VERIFY   Import book. Search book title in Spotlight → app result appears. Tap → app opens that book.
- [ ] 5.5  Siri NSUserActivity
  TARGET   Features/Reader/ReaderView.swift (update)
  IMPL     In ReaderView.onAppear: userActivity = NSUserActivity(activityType: “com.yourname.epubreader.reading”). Set title, isEligibleForSearch=true, isEligibleForPrediction=true, persistentIdentifier=bookID.uuidString. Set userInfo with bookID. becomeCurrent(). resignCurrent() in onDisappear. In App.onContinueUserActivity: handle this activityType → navigate to correct book. Add NSUserActivityTypes to Info.plist.
  VERIFY   Read a book. Say “Hey Siri, show my EpubReader activity” → Siri can offer to continue reading.

PHASE_5_MILESTONE: Search “whale” in Moby Dick → results listed. Search “Melville” in library → book found. Book appears in Spotlight.

## PHASE 6a — ICLOUD SYNC

Goal: progress, highlights, bookmarks sync across devices.

- [ ] 6a.1  Migrate to NSPersistentCloudKitContainer
  TARGET   Core/Persistence/PersistenceController.swift (update)
  IMPL     Replace NSPersistentContainer with NSPersistentCloudKitContainer. Add CloudKit capability in Xcode (iCloud → CloudKit, container: iCloud.com.yourname.epubreader). Set persistentStoreDescriptions[0].cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier:). Set NSPersistentHistoryTrackingKey=true and NSPersistentStoreRemoteChangeNotificationPostOptionKey=true in storeDescription options. Set viewContext.automaticallyMergesChangesFromParent=true. Set viewContext.mergePolicy=NSMergeByPropertyObjectTrumpMergePolicy.
  VERIFY   App launches with CloudKit container. No crash. CloudKit dashboard shows schema after first run.
- [ ] 6a.2  Conflict resolution implementation
  TARGET   Core/Persistence/CloudKitSync.swift
  IMPL     Observe NSPersistentCloudKitContainer remoteChange notifications. For ReadingProgress conflicts: fetch both local and remote versions (via persistent history), keep the one with newer updatedAt. For Highlight conflicts: if cfiRange matches and colorName differs, keep newer updatedAt. If cfiRange is new, insert. For Bookmark: union insert (never delete remote). Implement soft-delete: Book.isDeleted flag; do not sync deletions immediately — set deletedAt, sync the flag, purge after 30 days in a background cleanup task.
  VERIFY   Simulate conflict (modify same ReadingProgress on two simulators offline, then both go online) → newer one wins.
- [ ] 6a.3  EPUB file sync via iCloud Drive
  TARGET   Core/Utilities/FileImporter.swift (update)
  IMPL     After book import: copy EPUB file to NSFileManager.default.url(forUbiquityContainerIdentifier:nil) / Documents / sha256.epub. Use NSMetadataQuery to observe iCloud files. On new iCloud file detected: download with startDownloadingUbiquitousItem, then import normally. Ensure app can open EPUBs from either local or iCloud path (check NSURLUbiquitousItemDownloadingStatusKey before opening).
  VERIFY   Import book on device 1. iCloud Drive shows the file. On device 2 (same account), file eventually appears and can be opened.
- [ ] 6a.4  Sync status UI
  TARGET   Features/Library/LibraryView.swift (update)
  IMPL     In LibraryView toolbar: small Circle indicator. Green (NSPersistentCloudKitContainer.Event.type==.export, succeeded). Yellow (in-progress or pending). Red (any failed event). Observe NSPersistentCloudKitContainer.eventChangedNotification. Tap indicator → sheet explaining “Syncing with iCloud…” or “Last synced: Xm ago” or error message.
  VERIFY   Sync in progress → yellow dot. Completed → green dot. Tap → status sheet appears.

PHASE_6a_MILESTONE: Read page 30 on device 1. Open app on device 2 (same iCloud). Same book at page 30 within 10 seconds.

## PHASE 6b — KOREADER SYNC

Goal: reading position syncs bidirectionally with KOReader.

- [ ] 6b.1  Implement KOReaderSync client
  TARGET   Features/Integrations/KOReaderSync.swift
  IMPL     Actor KOReaderSync. Stores serverURL: URL, username: String, token: String (Keychain). func register(serverURL: URL, username: String, password: String) async throws: POST /users/create. func authenticate() async throws: POST /users/auth → store token in Keychain. func pushProgress(bookSHA256: String, cfi: String, percentage: Double) async throws: PUT /syncs/progress with body {document:sha256, progress:cfi, percentage:pct, device:“iPhone”, device_id:UIDevice.current.identifierForVendor}. func pullProgress(bookSHA256: String) async throws -> (cfi: String, percentage: Double)?: GET /syncs/progress/sha256 → decode response.
  VERIFY   With a running KOReader sync server: register, auth token returned, pushProgress succeeds (HTTP 200).
- [ ] 6b.2  Sync triggers and conflict resolution
  TARGET   Features/Integrations/KOReaderSync.swift (update), Features/Reader/ReaderViewModel.swift (update)
  IMPL     Trigger push: in ReaderViewModel, after CFI save to Core Data, also call KOReaderSync.pushProgress() if sync enabled for this book (debounced 5s). Trigger pull: on ReaderView.onAppear. Conflict: compare pulled percentage vs local percentage; use higher value (user has read further on either device). Update local ReadingProgress if remote is ahead.
  VERIFY   Read to 30% on iPhone. Read to 50% on Kindle (KOReader). Open iPhone → progress updates to 50%.
- [ ] 6b.3  KOReader sync settings UI
  TARGET   Features/Settings/SyncSettings.swift (update)
  IMPL     Section in SyncSettings: “KOReader Sync”. Server URL TextField. Username TextField. Password SecureField (Keychain backed). “Test Connection” button → shows ✓ Connected or error. Enable/disable toggle. Last sync timestamp. List of books with sync enabled toggle per-book.
  VERIFY   Enter valid server details. Tap Test Connection → shows ✓. Settings persist. Toggle sync for specific book → only that book syncs.

PHASE_6b_MILESTONE: Read on Kindle (KOReader). Open iPhone. Book at same position.

## PHASE 6c — CALIBRE AND OPDS

Goal: browse and download from Calibre and OPDS catalogs.

- [ ] 6c.1  Implement OPDS parser
  TARGET   Features/Integrations/OPDSBrowser.swift
  IMPL     Actor OPDSParser. struct OPDSFeed: id, title, entries([OPDSEntry]), nextURL(URL?). struct OPDSEntry: id, title, author, summary, updated, acquisitionLinks([OPDSLink]), navigationLinks([OPDSLink]), thumbnailURL(URL?). struct OPDSLink: rel, type, href. func parseFeed(from url: URL) async throws -> OPDSFeed: URLSession.data(from:), parse Atom XML with XMLParser. Detect entry type by link rel: “http://opds-spec.org/acquisition” = download, “subsection” or “self” = navigation. Handle pagination via rel=“next” link.
  VERIFY   Parse https://standardebooks.org/opds → OPDSFeed with >0 entries, each with title and at least one link.
- [ ] 6c.2  Build OPDS browser UI
  TARGET   Features/Integrations/OPDSBrowserView.swift
  IMPL     NavigationStack. Root: list of saved OPDSServer entries + Standard Ebooks (hardcoded, undeletable). Tap catalog → push new OPDSBrowserView for that feed URL. Each OPDSEntry cell: thumbnail (AsyncImage), title, author. If entry has acquisitionLinks: show download button (arrow.down.circle) inline. If navigationLinks only: tap to drill in. Search bar if feed has OPDS search template (rel=“search”). Download progress: overlay on cell.
  VERIFY   Browse Standard Ebooks. Tap a category. See books. Tap download → book imports into library.
- [ ] 6c.3  Implement CalibreClient
  TARGET   Features/Integrations/CalibreClient.swift
  IMPL     Actor CalibreClient. struct CalibreBook: id(Int), title, authors([String]), coverURL(URL?), formats([String]). func connect(url: URL, username: String?, password: String?) async throws: GET /ajax/library-info → verify 200. func search(query: String, library: String?) async throws -> [CalibreBook]: GET /ajax/search?q=query → parse book ids, then GET /ajax/books?ids=… → parse metadata. func downloadEPUB(id: Int, library: String) async throws -> URL: GET /get/epub/{id}/{library} → save to temp, return URL. Credentials stored in Keychain.
  VERIFY   With running Calibre server: connect succeeds. Search returns books. Download returns valid EPUB file.
- [ ] 6c.4  Build Calibre browser UI
  TARGET   Features/Integrations/CalibreView.swift
  IMPL     Sheet or tab. SearchBar at top (searches Calibre server). Results grid with CalibreBook cells: cover from /get/cover/{id}/ via AsyncImage, title, authors. Tap → detail sheet with all metadata + “Download EPUB” button showing download progress. Add downloaded book to library via FileImporter pipeline. Settings section for server URL, credentials (from SyncSettings).
  VERIFY   Connect to Calibre. Search. Download a book. It appears in app library with cover.
- [ ] 6c.5  Add OPDS server management
  TARGET   Features/Settings/SyncSettings.swift (update)
  IMPL     “OPDS Catalogs” section. List of OPDSServer (struct: name, url, username?, password?). Swipe to delete (not Standard Ebooks). Add button → sheet with Name/URL/Auth TextFields and “Test” button that calls OPDSParser.parseFeed() → shows feed title on success. Saved to UserDefaults as [OPDSServer] (Codable). Standard Ebooks entry hardcoded at top.
  VERIFY   Add custom OPDS server. Test shows success. It appears in OPDS browser. Delete → gone. Standard Ebooks cannot be deleted.

PHASE_6c_MILESTONE: Browse Standard Ebooks, download book, appears in library. Connect Calibre, search, download, appears in library.
~GATE_2_TESTFLIGHT_BETA~ READY AFTER THIS TASK.

## PHASE 7a — WIDGETS AND PLATFORM

Goal: lock screen widget, home screen widget, Dynamic Island, DeepL.

- [ ] 7a.1  Set up App Group and Widget Extension target
  TARGET   EpubReader.xcodeproj
  IMPL     Add App Group capability: group.com.yourname.epubreader to both main app and new Widget Extension target. Update PersistenceController: use FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: “group.com.yourname.epubreader”) as store URL. Create Widget Extension target (File→New→Target→Widget Extension) named EpubReaderWidget. Import shared Core Data model into widget target.
  VERIFY   Widget extension builds. PersistenceController.shared works from both app and widget targets.
- [ ] 7a.2  Lock screen widget
  TARGET   EpubReaderWidget/LockScreenWidget.swift
  IMPL     Widget with supportedFamilies: [.accessoryRectangular, .accessoryInline]. Timeline provider fetches current ReadingProgress from shared Core Data. AccessoryRectangular entry view: HStack with book cover (10pt corner radius, 30×40pt) + VStack(title truncated 1 line, ProgressView linear value:percentage). AccessoryInline: “📖 [Title] [X]%”. DeepLink URL: epubreader://book/{bookID} — handle in App with onOpenURL.
  VERIFY   Add to lock screen. Shows current book title and progress. Tap → opens app at that book.
- [ ] 7a.3  Home screen widget
  TARGET   EpubReaderWidget/HomeScreenWidget.swift
  IMPL     supportedFamilies: [.systemSmall, .systemMedium]. Small: book cover (full bleed with gradient overlay), title bottom-left, progress top-right, streak badge. Medium: same cover left half, right half: title, author, last-read relative time (“2 hours ago”), progress bar, current chapter name. All tap → deeplink to continue reading.
  VERIFY   Both sizes display on home screen with correct data. Tap opens reader at last position.
- [ ] 7a.4  Dynamic Island Live Activity
  TARGET   Features/TTS/TTSController.swift (update), EpubReaderWidget/ReadingLiveActivity.swift
  IMPL     Define ReadingActivityAttributes: struct with bookTitle, author. ContentState: chapterName, isPlaying, sentencePreview(String). In TTSController.play(): ActivityKit.Activity<ReadingActivityAttributes>.request(…). Update state on sentence change. End on stop(). Live Activity view: compact leading = speaker icon, compact trailing = book title truncated. Minimal = speaker icon. Expanded = book title + chapter + play/pause button.
  VERIFY   Start TTS → Dynamic Island shows. Tap expanded → speaker icon + chapter name. Stop TTS → disappears.
- [ ] 7a.5  Focus Mode filter
  TARGET   App/AppEntry.swift (update)
  IMPL     Add AppIntentConfiguration conforming to SetFocusFilterIntent protocol. EpubReaderFocusFilter: title “Reading”, description “Hides distractions while reading”. When filter is active and reader is open: suppress badge updates. Register with AppIntentConfiguration in @main.
  VERIFY   Create “Reading” Focus in iOS Settings using EpubReader filter. While in reader with that Focus active, badge count not shown.
- [ ] 7a.6  DeepL translation
  TARGET   Features/Reader/TranslationPanel.swift, Features/Reader/ReaderView.swift (update)
  IMPL     TranslationPanel: half-sheet with source text (italic, secondary), translated text (primary, selectable), language pair label, “Copy Translation” button. In selection context menu “Translate” action: POST https://api-free.deepl.com/v2/translate with auth_key from Keychain (user enters in Settings), text, target_lang (from device locale). Cache results in [String:String] dict (source text hash → translated text) for app session. If no API key: show Settings prompt.
  VERIFY   Select text. Tap Translate. Sheet shows translated text. Tap again → instant (from cache). Copy button copies translation.

PHASE_7a_MILESTONE: Widget on home + lock screen. Dynamic Island shows during TTS. DeepL translate works.

## PHASE 7b — POLISH, PERFORMANCE, ACCESSIBILITY

Goal: reading stats, smart collections, haptics, perf pass, VoiceOver, iPad.

- [ ] 7b.1  Reading stats and goals
  TARGET   Core/Models/ReadingSession.swift, Features/Settings/ReadingStatsView.swift
  IMPL     ReadingSession entity: bookID, startedAt, endedAt, wordsRead(Int32). In ReaderViewModel: record session start on onAppear, end on onDisappear, estimate wordsRead from (endCFIPercentage - startCFIPercentage) × estimatedBookWords. ReadingStatsView: daily reading time bar chart (Swift Charts, last 7 days), current streak (consecutive days with >0 reading), words read this week, all-time. Goals: UserDefaults dailyGoalMinutes (default 30), ring progress view. Present from Settings.
  VERIFY   Read for 2 minutes. Stats view shows today’s bar > 0. Streak increments.
- [ ] 7b.2  Smart collections
  TARGET   Features/Library/LibraryViewModel.swift (update), Features/Library/LibraryView.swift (update)
  IMPL     Four auto-collections fetched via NSFetchRequest: “Currently Reading” (percentage > 0.01 AND < 0.99), “Finished” (percentage >= 0.99), “Recently Added” (importedAt within 30 days), “Unread” (percentage == 0 or nil). Show as horizontal scroll row of shelf chips above main grid. Tap chip → filters main grid to that collection. Implement as @FetchRequest properties in LibraryViewModel.
  VERIFY   Mark a book as finished. “Finished” collection appears with that book. “Currently Reading” shows in-progress book.
- [ ] 7b.3  Haptic feedback
  TARGET   Across codebase — add calls at specific points
  IMPL     Page turn: UIImpactFeedbackGenerator(style:.light).impactOccurred(). Highlight created: UIImpactFeedbackGenerator(style:.medium).impactOccurred(). Bookmark added: UINotificationFeedbackGenerator().notificationOccurred(.success). Long-press detected: UIImpactFeedbackGenerator(style:.rigid).impactOccurred(). Every call guarded by: guard !UIAccessibility.isReduceMotionEnabled else { return }. Extract into HapticEngine singleton with named methods.
  VERIFY   Page turn on physical device → subtle haptic felt. Accessibility reduce motion on → no haptic.
- [ ] 7b.4  Performance profiling and fixes
  TARGET   Instruments profiling (no specific file — fix whatever is slow)
  IMPL     Profile with Instruments Time Profiler: (1) EPUB open time — target <1.5s; if slow, parallelize extraction+parsing; cache locations. (2) Page turn — target <50ms; if slow, check JS evaluation time, ensure WKWebView not re-created per chapter. (3) Library load 100 books — target <0.5s; use NSFetchedResultsController not @FetchRequest if needed. (4) Memory — verify WKWebView pool never exceeds 3; verify no leaked Core Data contexts. Fix all regressions found.
  VERIFY   EPUB opens in <1.5s measured via XCTest performance test. Library with 100 items scrolls at 60fps.
- [ ] 7b.5  Accessibility audit
  TARGET   All Views — add accessibilityLabel/accessibilityHint/accessibilityValue where missing
  IMPL     VoiceOver: each BookGridCell needs accessibilityLabel = “(title) by (author), (Int(percentage*100)) percent read”. BookmarkPanel rows: accessibilityLabel = “(label), (chapterName)”. Highlight rows: “Highlight: (selectedText)”. Buttons with icon-only need accessibilityLabel. Dynamic Type: all font(.body), font(.caption) etc use relative sizes (not fixed pt). Reduce motion: page curl → crossfade with `.transition(.opacity)`. Reduce transparency: .ultraThinMaterial → .regularMaterial.
  VERIFY   Enable VoiceOver. Navigate library by swipe. Every element announced with useful description. Enable Dynamic Type XXL → no clipping.
- [ ] 7b.6  iPad layout
  TARGET   App/NavigationCoordinator.swift (update), Features/Library/LibraryView.swift (update)
  IMPL     Use NavigationSplitView on iPad (horizontalSizeClass == .regular): sidebar shows LibraryView (shelves + grid), detail shows ReaderView. On iPhone: NavigationStack as before. Use @Environment(.horizontalSizeClass). Sidebar on iPad supports drag-and-drop reorder of shelves. Reader on iPad: wider margins (auto via rendition width), larger font default. Drop of .epub files from Files app via onDrop with UTType.epub.
  VERIFY   On iPad: sidebar + reader side by side. Drag EPUB from Files app → imports and opens.

PHASE_7b_MILESTONE: Stats, collections, haptics all work. <1.5s open time. VoiceOver navigates library. iPad layout correct.
~GATE_3_APPSTORE_V1~ READY AFTER THIS TASK.

## PHASE 8 — PDF SUPPORT

Goal: PDF reads, highlights, bookmarks, TTS, search with same UX as EPUB.

- [ ] 8.1  Implement PDFReader
  TARGET   Core/PDF/PDFReader.swift
  IMPL     struct PDFReader: UIViewRepresentable. Wraps PDFView. Configure: displayMode = .singlePage, displayDirection = .horizontal, usePageViewController = true, autoScales = true. Detect current theme from ReaderAppearance and set backgroundColor. Coordinator conforms to PDFViewDelegate: pdfViewPageChanged → update ReaderViewModel.pdfPageIndex. Expose: func go(to page: Int), func zoomToFit().
  VERIFY   Open a PDF → renders page 1. Swipe → pages turn with curl. Auto-detects dark mode.
- [ ] 8.2  PDF progress tracking
  TARGET   Features/Reader/ReaderViewModel.swift (update)
  IMPL     Add @Published pdfPageIndex: Int = 0. On pdfViewPageChanged: save to ReadingProgress Core Data with cfi = “pdf-page-(index)” and percentage = Double(index) / Double(totalPages). On open: fetch ReadingProgress → if cfi starts with “pdf-page-”, parse index and call PDFReader.go(to:).
  VERIFY   Open PDF, go to page 10, quit. Reopen → page 10.
- [ ] 8.3  PDF text selection and highlights
  TARGET   Core/PDF/PDFAnnotationBridge.swift
  IMPL     PDFViewDelegate: pdfView(_:didSelect:) - get selected PDFSelection, show same selection context menu as EPUB reader (Highlight colors, Copy, Look Up, Translate). On highlight: create PDFAnnotation(bounds:forType:.highlight) with color, add to PDFPage, call PDFDocument.write(to: originalURL) to persist. Store Highlight in Core Data with cfi=“pdf-page-(pageIndex)-(selectionString.hash)” for annotation management.
  VERIFY   Select text in PDF. Tap yellow highlight → text highlighted. Reopen → highlight still there.
- [ ] 8.4  PDF bookmarks
  TARGET   Features/Annotations/BookmarkPanel.swift (update)
  IMPL     “Add Bookmark” in reader overlay creates Bookmark with cfi=“pdf-page-(pageIndex)”, label=“Page (pageIndex+1)”. BookmarkPanel shows PDF bookmarks same as EPUB. Tap → PDFReader.go(to: pageIndex). No changes needed to Core Data schema.
  VERIFY   Bookmark page 5. Open bookmark panel. Tap → PDF goes to page 5.
- [ ] 8.5  PDF thumbnail strip and zoom
  TARGET   Core/PDF/PDFReader.swift (update)
  IMPL     Add PDFThumbnailView in reader overlay bottom bar (replaces progress scrubber for PDFs). Height 60pt, thumbnailSize CGSize(30,40). Horizontal scroll. Tap thumbnail → PDFReader.go(to: index). Pinch gesture: webView approach not applicable; PDFView handles pinch natively, just set min/max scaleFactor (0.5 to 4.0). Double-tap → pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit.
  VERIFY   Thumbnail strip visible. Tap thumbnail → jumps to that page. Pinch zooms. Double-tap → fits width.
- [ ] 8.6  PDF TTS
  TARGET   Features/TTS/TTSController.swift (update)
  IMPL     Add func prepareChapterFromPDF(document: PDFDocument, startPage: Int). Extract text: (startPage..<min(startPage+10, document.pageCount)).compactMap { document.page(at:$0)?.string }.joined(separator:” “). Tokenize into sentences via NLTokenizer. For each sentence, track which page it came from. On sentence advance: if page changes, call PDFReader.go(to: nextPage). TTSBar and controls unchanged.
  VERIFY   Start TTS on PDF. Reads aloud. Advances pages. Lock screen shows controls.
- [ ] 8.7  PDF in-book search
  TARGET   Features/Search/InBookSearchView.swift (update)
  IMPL     When current file is PDF: use PDFDocument.findString(query, withOptions:.caseInsensitive) → [PDFSelection]. Display results with page number + excerpt (selection.string). Tap → pdfView.go(to: selection); pdfView.setCurrentSelection(selection, animate:true). PDFView highlights selection natively.
  VERIFY   Search “whale” in PDF Moby Dick → results with page numbers. Tap → jumps to page with selection highlighted.
- [ ] 8.8  Password-protected PDF
  TARGET   Features/Reader/ReaderViewModel.swift (update)
  IMPL     On PDF open: if PDFDocument(url:) returns nil or .isLocked: show alert with SecureField “Enter password”. On submit: call document.unlock(withPassword:). On success: store password in Keychain keyed by file sha256. On subsequent open: try Keychain password automatically before prompting.
  VERIFY   Open password-protected PDF → password prompt. Enter wrong → error shown. Enter correct → PDF opens. Close and reopen → no prompt (Keychain).

PHASE_8_MILESTONE: Open PDF, read, highlight, bookmark, search, TTS. Password-protected PDF handled.
~GATE_4_V1_1~ READY AFTER THIS TASK.

<!-- ============================================================
  AFTER ALL TASKS COMPLETE
============================================================ -->

POST_COMPLETION_CHECKLIST:
[ ] All unit tests passing (xcodebuild test)
[ ] No compiler warnings
[ ] App Store privacy manifest complete (PrivacyInfo.xcprivacy)
[ ] App icons all sizes in Assets.xcassets
[ ] Launch screen configured
[ ] TestFlight build uploaded and tested on physical device
[ ] App Store Connect metadata prepared (screenshots, description)
