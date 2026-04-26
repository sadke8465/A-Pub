import Combine
import Foundation

@MainActor
public final class ReaderViewModel: ObservableObject {

    @Published public var book: EPUBBook?
    @Published public var isLoading = false
    @Published public var currentCFI: String = ""
    @Published public var percentage: Double = 0
    @Published public var isOverlayVisible = true

    @Published public var base64Book: String = ""
    @Published public var escapedBase64Book: String = ""
    @Published public var bridge = EPUBBridge()
    @Published public var currentSpineIndex = 0

    let pageController = PageController()

    private let importer: FileImporter
    private let initialBookFileURL: URL?
    private let initialBookID: UUID?
    private var didAttemptInitialLoad = false
    private var pendingRestoreCFI: String?

    public init(
        importer: FileImporter = FileImporter(),
        initialBookFileURL: URL? = nil,
        initialBookID: UUID? = nil
    ) {
        self.importer = importer
        self.initialBookFileURL = initialBookFileURL
        self.initialBookID = initialBookID
        configureBridgeCallbacks()
    }

    public func loadFromFile() {
        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                let result = try await importer.importSingleEPUBForReader()
                book = result.0
                base64Book = result.1
                escapedBase64Book = result.2
            } catch is CancellationError {
                Log.shared.info("User cancelled EPUB import")
            } catch {
                Log.shared.error("Failed to import EPUB: \(error.localizedDescription)")
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
            if let initialBookID {
                pageController.currentBookID = initialBookID
                pendingRestoreCFI = await pageController.restoreCFI(for: initialBookID)
            }
            await loadFromLibrary(fileURL: initialBookFileURL)
        }
    }

    func handleBookReady(in pageCurlVC: PageCurlViewController?) {
        guard let pendingRestoreCFI else {
            return
        }
        let escapedCFI = pendingRestoreCFI.replacingOccurrences(of: "'", with: "\\'")
        pageCurlVC?.displayCFI(escapedCFI)
        self.pendingRestoreCFI = nil
    }

    func handleRelocated(
        cfi: String,
        pct: Double,
        spineHref: String,
        characterOffset: Int64,
        contextSnippet: String,
        atEnd: Bool
    ) {
        currentCFI = cfi
        percentage = pct
        updateCurrentSpineIndex(using: spineHref)
        pageController.onRelocated(
            cfi: cfi,
            pct: pct,
            spineHref: spineHref,
            characterOffset: characterOffset,
            contextSnippet: contextSnippet,
            atEnd: atEnd
        )
    }

    public func toggleOverlay() {
        isOverlayVisible.toggle()
    }

    public func teardownReader() {
        pageController.currentBookID = nil
        bridge.invalidate()
    }

    private func loadFromLibrary(fileURL: URL) async {
        isLoading = true
        defer { isLoading = false }

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
        } catch {
            Log.shared.error("Failed to open library EPUB: \(error.localizedDescription)")
        }
    }

    private func configureBridgeCallbacks() {
        bridge.onRelocated = { [weak self] cfi, pct, spineHref, _, _ in
            guard let self else { return }
            self.handleRelocated(
                cfi: cfi,
                pct: pct,
                spineHref: spineHref,
                characterOffset: 0,
                contextSnippet: "",
                atEnd: false
            )
        }

        bridge.onBookReady = {
            Log.shared.info("EPUB book ready")
        }

        bridge.onBookError = { message in
            Log.shared.error("EPUB book load failed: \(message)")
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
