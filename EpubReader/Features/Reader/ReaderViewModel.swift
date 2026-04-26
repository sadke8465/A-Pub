import Combine
import CoreData
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
    @Published public var lastJavaScriptExecutionError: String?

    let pageController = PageController()
    let appearance: ReaderAppearance

    private let importer: FileImporter
    private let initialBookFileURL: URL?
    private let initialBookID: UUID?
    private var didAttemptInitialLoad = false
    private var pendingRestoreCFI: String?
    private var needsLocationsSnapshotAfterReflow = false

    init(
        importer: FileImporter = FileImporter(),
        initialBookFileURL: URL? = nil,
        initialBookID: UUID? = nil,
        appearance: ReaderAppearance = ReaderAppearance()
    ) {
        self.importer = importer
        self.initialBookFileURL = initialBookFileURL
        self.initialBookID = initialBookID
        self.appearance = appearance
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
                await loadAppearanceOverride(for: initialBookID)
            }
            await loadFromLibrary(fileURL: initialBookFileURL)
        }
    }

    func handleBookReady(in pageCurlVC: PageCurlViewController?) {
        pageCurlVC?.applyAppearance(appearance)

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

        if needsLocationsSnapshotAfterReflow {
            needsLocationsSnapshotAfterReflow = false
            bridge.requestLocationsSnapshot()
        }
    }


    func handleAppearanceChange() {
        pageController.invalidatePaginationMetricsForReflow()
        needsLocationsSnapshotAfterReflow = true
    }

    func handleJavaScriptExecutionFailure(_ failure: EPUBBridge.JavaScriptExecutionFailure) {
        let message = """
        JavaScript execution failed for \(failure.commandPrefix) \
        [\(failure.errorDomain):\(failure.errorCode)] \(failure.message)
        """
        lastJavaScriptExecutionError = message
        Log.shared.error(message)
    }

    func saveCurrentAppearanceOverrideForCurrentBook() {
        guard let bookID = initialBookID else {
            Log.shared.debug("Skipping per-book appearance override save: no active library book id")
            return
        }

        let context = PersistenceController.shared.backgroundContext()
        let payload = ReaderAppearanceOverridePayload(
            fontFamily: appearance.fontFamily,
            fontSize: appearance.fontSize,
            theme: appearance.theme,
            lineSpacing: appearance.lineSpacing,
            marginStyle: appearance.marginStyle,
            textAlignment: appearance.textAlignment,
            hyphenation: appearance.hyphenation
        )

        Task<Void, Never> {
            await context.perform {
                let request = NSFetchRequest<Book>(entityName: "Book")
                request.predicate = NSPredicate(format: "id == %@", bookID as CVarArg)
                request.fetchLimit = 1

                do {
                    guard let storedBook = try context.fetch(request).first else {
                        Log.shared.error("Unable to save appearance override: Book not found")
                        return
                    }
                    storedBook.saveAppearanceOverride(payload)
                    try context.save()
                } catch {
                    Log.shared.error("Failed saving appearance override: \(error.localizedDescription)")
                }
            }
        }
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
            let (encoded, escaped) = try await Self.loadAndEncode(fileURL: fileURL)

            book = parsedBook
            base64Book = encoded
            escapedBase64Book = escaped
        } catch {
            Log.shared.error("Failed to open library EPUB: \(error.localizedDescription)")
        }
    }

    nonisolated private static func loadAndEncode(fileURL: URL) async throws -> (String, String) {
        try await Task.detached(priority: .userInitiated) {
            let data = try Data(contentsOf: fileURL)
            let encoded = data.base64EncodedString()
            let escaped = encoded.replacingOccurrences(of: "'", with: "\\'")
            return (encoded, escaped)
        }.value
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

        bridge.onLocationsSnapshot = { [weak self] totalLocations, serializedLocations in
            guard let self else { return }
            self.pageController.updateTotalLocationCount(totalLocations)
            self.persistLocationsCache(serializedLocations)
        }

        bridge.onJavaScriptExecutionFailed = { [weak self] failure in
            self?.handleJavaScriptExecutionFailure(failure)
        }
    }

    private func loadAppearanceOverride(for bookID: UUID) async {
        let context = PersistenceController.shared.backgroundContext()
        if let payload = await context.perform({ () -> ReaderAppearanceOverridePayload? in
            let request = NSFetchRequest<Book>(entityName: "Book")
            request.predicate = NSPredicate(format: "id == %@", bookID as CVarArg)
            request.fetchLimit = 1

            do {
                return try context.fetch(request).first?.appearanceSettings()
            } catch {
                Log.shared.error("Failed loading appearance override: \(error.localizedDescription)")
                return nil
            }
        }) {
            appearance.fontFamily = payload.fontFamily
            appearance.fontSize = payload.fontSize
            appearance.theme = payload.theme
            appearance.lineSpacing = payload.lineSpacing
            appearance.marginStyle = payload.marginStyle
            appearance.textAlignment = payload.textAlignment
            appearance.hyphenation = payload.hyphenation
        }
    }

    private func persistLocationsCache(_ serializedLocations: String?) {
        guard let bookID = initialBookID,
              let serializedLocations,
              !serializedLocations.isEmpty
        else {
            return
        }

        let context = PersistenceController.shared.backgroundContext()
        Task<Void, Never> {
            await context.perform {
                let request = NSFetchRequest<Book>(entityName: "Book")
                request.predicate = NSPredicate(format: "id == %@", bookID as CVarArg)
                request.fetchLimit = 1

                do {
                    guard let persistedBook = try context.fetch(request).first else {
                        return
                    }
                    persistedBook.locationsCache = serializedLocations
                    try context.save()
                } catch {
                    Log.shared.error("Failed saving locations cache: \(error.localizedDescription)")
                }
            }
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
