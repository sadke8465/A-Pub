# Gemini Code Assist Repository Audit - Resolution Checklist
**Repository:** sadke8465/A-Pub
**Exported On:** 25/04/2026

---

## Pull Request #10
[View PR on GitHub](https://github.com/sadke8465/A-Pub/pull/10)

- [ ] **File:** `EpubReader/Features/Reader/ReaderViewModel.swift` (Line 14) | **Priority: [CRITICAL]**
  The properties `base64Book`, `bridge`, and `currentSpineIndex` must be marked with `@Published`. Specifically, `bridge` needs to be `@Published` so that the `ReaderView` can correctly create a `Binding` to it (e.g., `$viewModel.bridge`), which is required by the `EPUBWebView` initializer. Without this, the code will fail to compile. Additionally, `currentSpineIndex` and `base64Book` should be published to ensure the UI stays in sync with the underlying state.
  ```swift
  @Published public var base64Book: String = ""
  @Published public var bridge = EPUBBridge()
  @Published public var currentSpineIndex = 0

```
 * [ ] **File:** EpubReader/Core/Utilities/FileImporter.swift (Line 26) | **Priority: [HIGH]**
   Loading the entire EPUB file into a Data object and then encoding it to a base64 string are heavy operations. Since FileImporter is bound to the @MainActor, these synchronous calls will block the main thread and freeze the UI, especially for larger books. Consider moving these operations to a background thread or using a non-isolated context.
 * [ ] **File:** EpubReader/Features/Reader/ReaderView.swift (Line 21) | **Priority: [HIGH]**
   There are two issues in this block:
   1. The JS call loadBook('\\(escaped)') contains a typo: the double backslash will result in a literal backslash being prepended to the base64 string in the JavaScript call (e.g., loadBook('\base64...')), which will cause the book to fail to load.
   2. Performing replacingOccurrences on a potentially massive base64 string on the main thread can lead to significant UI performance degradation. This should ideally be handled before the data reaches the view layer.
   ```swift
   let escaped = viewModel.base64Book.replacingOccurrences(of: "'", with: "\\'")
   viewModel.bridge.callJS("loadBook('" + escaped + "')")
   
   ```
 * [ ] **File:** EpubReader/Features/Reader/ReaderViewModel.swift (Line 49) | **Priority: [MEDIUM]**
   The onRelocated closure currently only updates the CFI and percentage, but it fails to update currentSpineIndex. As a result, the currentChapterTitle in the view will always show the first chapter's label regardless of the user's actual position. You should implement logic to determine the current spine index from the relocation data and update self.currentSpineIndex here.
## Pull Request #9
View PR on GitHub
 * [ ] **File:** EpubReader/Features/Reader/EPUBWebView.swift (Line 16) | **Priority: [MEDIUM]**
   Using @Binding with a class type (EPUBBridge) is generally unnecessary in SwiftUI. Bindings are intended for value types where you need to propagate mutations back to the source of truth. Since EPUBBridge is a reference type, a simple let bridge: EPUBBridge is sufficient to access its properties and methods. If the view needs to react to changes within the bridge, EPUBBridge should conform to ObservableObject and be used with @ObservedObject (or @Bindable for Swift 5.9+).
 * [ ] **File:** EpubReader/Features/Reader/EPUBWebView.swift (Line 50) | **Priority: [MEDIUM]**
   The Coordinator and makeCoordinator() method are currently redundant as they do not implement any delegate protocols (like WKNavigationDelegate) or handle any logic. The EPUBBridge already handles script messages and provides closure-based callbacks. Unless this is a placeholder for logic intended for the immediate next task, it should be removed to simplify the implementation.
 * [ ] **File:** EpubReader/Features/Reader/EPUBWebView.swift (Line 65) | **Priority: [MEDIUM]**
   Defining public methods like loadBook, nextPage, and prevPage on a SwiftUI View struct is an anti-pattern. SwiftUI views are transient value types that are frequently recreated; holding a reference to a view instance to call these methods is unreliable. These helper methods should be moved to the EPUBBridge class, which is a reference type and already holds the webView reference, allowing ViewModels to interact with the reader logic directly.
 * [ ] **File:** EpubReader/Features/Reader/EPUBWebView.swift (Line 54) | **Priority: [MEDIUM]**
   Using string interpolation to construct JavaScript calls is fragile and potentially slow for large payloads. If the base64 string contains characters that break the JS string literal (like single quotes), the call will fail. For passing data to WKWebView, it is safer and more performant to use webView.callAsyncJavaScript(_:arguments:in:in:) (available in iOS 14+) which handles argument serialization safely via a dictionary.
## Pull Request #8
View PR on GitHub
 * [ ] **File:** EpubReader/Features/Reader/EPUBBridge.swift (Line 96) | **Priority: [HIGH]**
   The deinit cleanup logic introduces a concurrency violation in Swift 6. WKUserContentController is not Sendable, so capturing it in a @MainActor task from a non-isolated deinit is unsafe. Additionally, nonisolated(unsafe) on line 30 is used to bypass actor isolation checks, which contradicts the project's goal of strict concurrency. It is recommended to move the script message handler removal to an explicit invalidation method called by the bridge's owner (e.g., when the reader view disappears) to ensure cleanup happens safely on the main actor.
 * [ ] **File:** EpubReader/Features/Reader/EPUBBridge.swift (Line 45) | **Priority: [MEDIUM]**
   The use of setValue(true, forKey: "allowFileAccessFromFileURLs") relies on a private WebKit preference. This is fragile and can lead to App Store rejection or unexpected behavior in future iOS updates. Since the project uses loadFileURL(_:allowingReadAccessTo:) (as per the master plan), it is better to ensure that all necessary assets are within the provided readAccessURL or use a custom WKURLSchemeHandler to serve content securely without resorting to private KVC hacks.
## Pull Request #7
View PR on GitHub
 * [ ] **File:** EpubReader/Core/EPUB/EPUBParser.swift (Line 339) | **Priority: [HIGH]**
   The resolveRelativePath function strips fragments (e.g., #section1) from URLs. In EPUB files, the Table of Contents (TOC) frequently points to specific anchors within a document. By stripping the fragment, navigation from the TOC will always land at the top of the file, breaking deep linking functionality. You should preserve the fragment during resolution.
   ```swift
   private func resolveRelativePath(_ path: String, from base: URL) -> URL {
       let parts = path.split(separator: "#", maxSplits: 1)
       let pathPart = String(parts.first ?? "")
       let fragment = parts.count > 1 ? String(parts[1]) : nil
   
       let decodedPath = pathPart.removingPercentEncoding ?? pathPart
       let fileURL = URL(fileURLWithPath: decodedPath, relativeTo: base).standardizedFileURL
   
       if let fragment, var components = URLComponents(url: fileURL, resolvingAgainstBaseURL: true) {
           components.fragment = fragment
           return components.url ?? fileURL
       }
       return fileURL
   }
   
   ```
 * [ ] **File:** EpubReader/Core/EPUB/EPUBParser.swift (Line 370) | **Priority: [HIGH]**
   The collectedText implementation incorrectly assumes that all text in a node comes before its children. In XML with mixed content (e.g., <a>Part 1: <span>The Beginning</span></a> or <a><span>Part 1:</span> The Beginning</a>), the current logic will produce incorrect strings like " The BeginningPart 1:" because it concatenates the node's own text (which accumulates all characters found while it was the current node) with its children's text. To fix this, XMLNode should store text segments and child nodes in a single ordered collection.
 * [ ] **File:** EpubReader/Core/EPUB/EPUBParser.swift (Line 333) | **Priority: [MEDIUM]**
   The logic for stripping namespace prefixes is duplicated between EPUBParser.stripPrefix and XMLNode.stripped (line 384). Additionally, you can avoid manual prefix stripping by setting parser.shouldProcessNamespaces = true in parseXMLTree, which allows the XMLParserDelegate to receive the localName directly.
## Pull Request #6
View PR on GitHub
 * [ ] **File:** EpubReader/Core/EPUB/EPUBExtractor.swift (Line 45) | **Priority: [MEDIUM]**
   The extract method performs synchronous file I/O and unzipping on the actor's executor. While this is thread-safe, a large EPUB file will block the actor for the duration of the extraction. If this actor is intended to be used for other tasks in the future, consider offloading the unzipItem call to a background thread or using a non-blocking API if available in ZIPFoundation to avoid blocking the cooperative thread pool.
 * [ ] **File:** EpubReader/Core/EPUB/EPUBExtractor.swift (Line 43) | **Priority: [MEDIUM]**
   While the master plan specifies throwing EPUBError.extractionFailed, this generic error swallows the underlying cause (e.g., out of disk space, permission issues, or a corrupted ZIP). Although the error is logged, the caller cannot programmatically distinguish between different failure modes. Consider adding an associated value to extractionFailed to carry the original error.
## Pull Request #5
View PR on GitHub
 * [ ] **File:** EpubReader/Resources/reader.css (Line 13) | **Priority: [MEDIUM]**
   When setting max-width: 100% on images, it is a best practice to also include height: auto. This ensures that if an image has a fixed height defined in the EPUB's internal CSS, it will scale proportionally rather than becoming vertically distorted when constrained by the width of the viewport.
   ```css
   img {
       max-width: 100%;
       height: auto;
   }
   
   ```
 * [ ] **File:** EpubReader/Resources/reader.css (Line 26) | **Priority: [MEDIUM]**
   For highlights that may span multiple lines, adding -webkit-box-decoration-break: clone; (and the standard box-decoration-break: clone;) ensures that the border-radius is applied to each line fragment individually. Without this, the highlight will appear 'cut off' at the end of the first line and the start of the second line.
   ```css
   .tts-highlight {
       background: rgba(254, 240, 138, 0.6);
       border-radius: 2px;
       -webkit-box-decoration-break: clone;
       box-decoration-break: clone;
   }
   
   ```
## Pull Request #4
View PR on GitHub
 * [ ] **File:** EpubReader/Resources/reader.html (Line 16) | **Priority: [MEDIUM]**
   The background color #FFFFFF deviates from the reader_bg_light design token (#FFFFF8) specified in the master plan (line 224). *(Reference: Design tokens specify reader_bg_light as #FFFFF8)*
 * [ ] **File:** EpubReader/Resources/reader.html (Line 47) | **Priority: [MEDIUM]**
   The loadBook function lacks error handling. If ePub() fails to initialize or rendition.display() throws an error (e.g., due to a corrupt file or invalid base64 data), the Swift bridge will not be notified, potentially leaving the application in a permanent loading state. It is recommended to wrap the logic in a try-catch block and communicate failures back to the bridge.
 * [ ] **File:** EpubReader/Resources/reader.html (Line 90) | **Priority: [MEDIUM]**
   Unconditionally calling window.book.locations.generate(1024) inside the ready handler and waiting for it to complete before sending bookReady violates the performance target of epub_open < 1.5s (line 234 of master-plan.md). Location generation is a computationally expensive operation that should be deferred or gated by the LOCATIONS_CACHE_RULE (line 249). The implementation instructions for Task 0.4 (line 280) do not require location generation at this stage.
## Pull Request #3
View PR on GitHub
 * [ ] **File:** refrence_files/master-plan.md (Line 274) | **Priority: [MEDIUM]**
   The task 0.3 is marked as completed, but the STATE block at the top of the file (lines 45-49) was not updated as required by the EXECUTION PROTOCOL (Step 6). Please update LAST_COMPLETED to 0.3, NEXT_TASK to 0.4, and increment TASKS_DONE to 3.
## Pull Request #2
View PR on GitHub
 * [ ] **File:** EpubReader/Core/Utilities/Logger.swift (Line 44) | **Priority: [HIGH]**
   This Log implementation has a few areas for improvement regarding performance, security, and robustness:
   1. **Performance**: A new os.Logger instance is created for every log call. Apple recommends creating logger instances once and reusing them. To fix this, you can cache the loggers by category. This requires changing Log from a struct to a class to manage the mutable cache state.
   2. **Security/Privacy**: All log messages are marked with privacy: .public. This is a security risk as it can leak sensitive information in production logs. It's safer to remove this and rely on the default behavior of os.Logger, which redacts dynamic content (.private).
   3. **Robustness**: Using a hardcoded fallback for the subsystem can lead to confusing logs if Bundle.main.bundleIdentifier is nil (e.g., in tests). It's better to fail fast with a preconditionFailure to ensure the logger is always correctly configured.
   ```swift
   public final class Log: Sendable {
       public static let shared = Log()
       private let subsystem: String
       private let lock = OSAllocatedUnfairLock()
       private var loggers: [String: os.Logger] = [:]
   
       private init() {
           guard let subsystem = Bundle.main.bundleIdentifier else {
               preconditionFailure("Could not determine bundle identifier for the logger subsystem.")
           }
           self.subsystem = subsystem
       }
   
       private func logger(for category: String) -> os.Logger {
           lock.withLock {
               if let logger = loggers[category] {
                   return logger
               }
               let newLogger = os.Logger(subsystem: subsystem, category: category)
               loggers[category] = newLogger
               return newLogger
           }
       }
   
       public func debug(_ message: @autoclosure () -> String, category: String = #fileID) {
           logger(for: category).debug("\(message())")
       }
   
       public func info(_ message: @autoclosure () -> String, category: String = #fileID) {
           logger(for: category).info("\(message())")
       }
   
       public func error(_ message: @autoclosure () -> String, category: String = #fileID) {
           logger(for: category).error("\(message())")
       }
   }
   
   ```
## Pull Request #1
View PR on GitHub
 * [ ] **File:** EpubReader.xcodeproj/project.pbxproj (Line 119) | **Priority: [HIGH]**
   The project specifies SWIFT_VERSION = 6.0 (lines 319, 352), but LastUpgradeCheck and CreatedOnToolsVersion are set to 1500 (Xcode 15). Swift 6 requires Xcode 16 (1600). This inconsistency will prevent the project from building correctly as Xcode 15 does not support Swift 6.
 * [ ] **File:** EpubReader/App/AppEntry.swift (Line 16) | **Priority: [MEDIUM]**
   Defining ContentView inside AppEntry.swift deviates from the architecture specified in master-plan.md. The ARCH (line 104) expects LibraryView.swift as the primary view, and the FILE_TREE (lines 96-110) suggests a modular structure where features are located in the Features/ directory. Consider renaming this placeholder to LibraryView and moving it to Features/Library/LibraryView.swift to align with the project plan.
```

```
