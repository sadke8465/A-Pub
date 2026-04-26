import Combine
import Foundation

@MainActor
public final class ReaderViewModel: ObservableObject {

    public enum BookLoadState: Equatable {
        case idle
        case loading
        case ready
        case error(message: String)
    }

    @Published public var book: EPUBBook?
    @Published public var bookLoadState: BookLoadState = .idle
    @Published public var currentCFI: String = ""
    @Published public var percentage: Double = 0
    @Published public var isOverlayVisible = true

    @Published public var base64Book: String = ""
    @Published public var escapedBase64Book: String = ""
    @Published public var bridge = EPUBBridge()
    @Published public var currentSpineIndex = 0
    @Published public var isWebHostReady = false
    @Published public var hasPendingBookPayload = false
    @Published public var isDiagnosticsPresented = false

    private let importer: FileImporter
    private let initialBookFileURL: URL?
    private var didAttemptInitialLoad = false

    public init(
        importer: FileImporter = FileImporter(),
        initialBookFileURL: URL? = nil
    ) {
        self.importer = importer
        self.initialBookFileURL = initialBookFileURL
        configureBridgeCallbacks()
    }

    public func loadFromFile() {
        Task {
            bookLoadState = .loading

            do {
                let result = try await importer.importSingleEPUBForReader()
                book = result.0
                base64Book = result.1
                escapedBase64Book = result.2
                hasPendingBookPayload = !result.2.isEmpty
                tryLoadBookIntoWebView()
            } catch is CancellationError {
                Log.shared.info("User cancelled EPUB import")
                if case .loading = bookLoadState {
                    bookLoadState = .idle
                }
            } catch {
                Log.shared.error("Failed to import EPUB: \(error.localizedDescription)")
                bookLoadState = .error(message: error.localizedDescription)
            }
        }
    }

    public func loadInitialBookIfNeeded() {
        guard !didAttemptInitialLoad else {
            return
        }
        didAttemptInitialLoad = true

        guard let initialBookFileURL else {
            return
        }

        Task {
            await loadFromLibrary(fileURL: initialBookFileURL)
        }
    }

    public func toggleOverlay() {
        isOverlayVisible.toggle()
    }

    public func teardownReader() {
        isWebHostReady = false
        bridge.invalidate()
    }

    private func loadFromLibrary(fileURL: URL) async {
        bookLoadState = .loading

        do {
            let extractor = EPUBExtractor()
            let parser = EPUBParser()
            let extractedRoot = try await extractor.extract(fileURL)
            let parsedBook = try await parser.parse(extractedRoot: extractedRoot)
            let data = try Data(contentsOf: fileURL)
            let encoded = data.base64EncodedString()

            book = parsedBook
            base64Book = encoded
            escapedBase64Book = encoded.replacingOccurrences(of: "'", with: "\\'")
            hasPendingBookPayload = !escapedBase64Book.isEmpty
            tryLoadBookIntoWebView()
        } catch {
            Log.shared.error("Failed to open library EPUB: \(error.localizedDescription)")
            bookLoadState = .error(message: error.localizedDescription)
        }
    }

    public func webViewReady() {
        isWebHostReady = true
        tryLoadBookIntoWebView()
    }

    public func tryLoadBookIntoWebView() {
        guard isWebHostReady,
              hasPendingBookPayload,
              !escapedBase64Book.isEmpty
        else {
            return
        }

        bookLoadState = .loading
        bridge.callJS("loadBook('\\(escapedBase64Book)')")
        hasPendingBookPayload = false
    }

    public func retryAfterError() {
        bookLoadState = .loading

        guard !escapedBase64Book.isEmpty else {
            loadFromFile()
            return
        }

        hasPendingBookPayload = true
        tryLoadBookIntoWebView()
    }

    public func openDiagnostics() {
        isDiagnosticsPresented = true
    }

    private func configureBridgeCallbacks() {
        bridge.onRelocated = { [weak self] cfi, pct, spineHref in
            guard let self else { return }
            self.currentCFI = cfi
            self.percentage = pct
            self.updateCurrentSpineIndex(using: spineHref)
        }

        bridge.onBookReady = { [weak self] in
            Log.shared.info("EPUB book ready")
            self?.bookLoadState = .ready
        }

        bridge.onBookError = { [weak self] message in
            guard let self else { return }
            Log.shared.error("EPUB book load failed: \(message)")
            self.bookLoadState = .error(message: message)
        }

        bridge.onJavaScriptEvalError = { [weak self] message in
            guard let self else { return }
            Log.shared.error("EPUB bridge JavaScript evaluation error: \(message)")
            self.bookLoadState = .error(message: message)
        }
    }

    private func updateCurrentSpineIndex(using spineHref: String) {
        guard !spineHref.isEmpty,
              let book,
              let relocatedURL = URL(string: spineHref)?
                .deletingFragment()
                .standardizedFileURL
        else {
            return
        }

        if let matchedIndex = book.spineItems.firstIndex(where: { chapter in
            chapter.href.deletingFragment().standardizedFileURL == relocatedURL
        }) {
            currentSpineIndex = matchedIndex
        }
    }
}

private extension URL {
    func deletingFragment() -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }
        components.fragment = nil
        return components.url ?? self
    }
}
