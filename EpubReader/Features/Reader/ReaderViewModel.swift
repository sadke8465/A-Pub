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

    @Published public var bookFileURL: URL?
    @Published public var legacyEscapedBase64Book: String = ""
    @Published public var bridge = EPUBBridge()
    @Published public var currentSpineIndex = 0
    @Published public var minutesRemainingInChapter = 0
    @Published public var lastJavaScriptExecutionError: String?
    @Published public var recoveryMessage: String?
    @Published public var readerStatusMessage: String?
    @Published public var isReaderContentReady = false
    @Published public var areLocationsReady = false
    @Published public var isRightToLeftReading = false

    let pageController = PageController()
    let appearance: ReaderAppearance

    private let importer: FileImporter
    private let initialBookFileURL: URL?
    private let initialBookID: UUID?
    private var didAttemptInitialLoad = false
    private var pendingRestoreCFI: String?
    private var needsLocationsSnapshotAfterReflow = false
    private let allowLegacyBase64Fallback = true
    private weak var pageCurlController: PageCurlViewController?
    private var jsGuardBlockedCount = 0
    private var wordCountsBySpineIndex: [Int: Int] = [:]
    private var averageWordsPerChapter: Int = 0
    private var personalizedWPM: Int = 238

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
            readerStatusMessage = "Opening..."
            defer { isLoading = false }

            do {
                let result = try await importer.importSingleEPUBForReader()
                bookFileURL = result.1
                legacyEscapedBase64Book = result.2 ?? ""
                book = result.0
                isRightToLeftReading = Self.isRightToLeftLanguage(result.0.language)
            } catch is CancellationError {
                Log.shared.info("User cancelled EPUB import")
            } catch {
                Log.shared.error("Failed to import EPUB: \(error.localizedDescription)")
                readerStatusMessage = nil
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
        pageCurlController = pageCurlVC
        pageCurlVC?.applyAppearance(appearance)
        pageCurlVC?.setRightToLeftReading(isRightToLeftReading)
        loadPersonalizedReadingSpeed()
        requestCurrentChapterWordCount()

        guard let pendingRestoreCFI else {
            readerStatusMessage = isReaderContentReady ? nil : "Paginating..."
            return
        }
        readerStatusMessage = "Restoring location..."
        pageCurlVC?.displayCFI(pendingRestoreCFI)
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
            pageCurlController?.requestLocationsSnapshot()
        }

        updateMinutesRemaining(characterOffset: characterOffset)
    }


    func handleAppearanceChange() {
        pageController.invalidatePaginationMetricsForReflow()
        needsLocationsSnapshotAfterReflow = true
        areLocationsReady = false
        readerStatusMessage = "Paginating..."
    }

    func handleJavaScriptExecutionFailure(_ failure: EPUBBridge.JavaScriptExecutionFailure) {
        let message = """
        JavaScript execution failed for \(failure.commandPrefix) \
        [\(failure.errorDomain):\(failure.errorCode)] \(failure.message) \
        [slot=\(failure.slotIndex.map(String.init) ?? "n/a") state=\(failure.slotState ?? "n/a") \
        token=\(failure.loadToken.map(String.init) ?? "n/a") family=\(failure.commandFamily ?? "n/a")]
        """
        lastJavaScriptExecutionError = message
        Log.shared.error(message)
    }

    func handleJSGuardBlocked(_ event: EPUBBridge.JSGuardBlockedEvent) {
        jsGuardBlockedCount += 1
        Log.shared.error("JS guard blocked command=\(event.command) reason=\(event.reason)")
        if jsGuardBlockedCount >= 3 {
            recoveryMessage = "Reloading chapter…"
        }
    }

    func handleRenderState(slotIndex: Int, event: EPUBBridge.RenderStateEvent) {
        if event.hasReadableText {
            recoveryMessage = nil
        }
        Log.shared.debug(
            """
            Reader renderState slot=\(slotIndex) phase=\(event.phase) \
            textLength=\(event.textLength) iframeCount=\(event.iframeCount) \
            spine=\(event.spineIndex):\(event.spineHref)
            """
        )
    }

    func handleFirstContentReady(slotIndex: Int, event: EPUBBridge.FirstContentReadyEvent) {
        isReaderContentReady = true
        readerStatusMessage = nil
        isOverlayVisible = false
        recoveryMessage = nil
        Log.shared.info(
            """
            Reader firstContentReady slot=\(slotIndex) phase=\(event.phase) \
            textLength=\(event.textLength) spine=\(event.spineIndex):\(event.spineHref)
            """
        )
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

    func attachPageCurlController(_ controller: PageCurlViewController?) {
        pageCurlController = controller
        controller?.setRightToLeftReading(isRightToLeftReading)
    }

    public func teardownReader() {
        pageController.currentBookID = nil
        pageCurlController = nil
        bridge.invalidate()
    }

    private func loadFromLibrary(fileURL: URL) async {
        isLoading = true
        isReaderContentReady = false
        areLocationsReady = false
        readerStatusMessage = "Opening..."
        defer { isLoading = false }

        do {
            let extractor = EPUBExtractor()
            let parser = EPUBParser()
            let extractedRoot = try await extractor.extract(fileURL)
            let parsedBook = try await parser.parse(extractedRoot: extractedRoot)

            let escapedBase64 = allowLegacyBase64Fallback
                ? (try await Self.loadAndEscapeBase64(fileURL: fileURL))
                : ""
            bookFileURL = fileURL
            legacyEscapedBase64Book = escapedBase64
            book = parsedBook
            isRightToLeftReading = Self.isRightToLeftLanguage(parsedBook.language)
            pageCurlController?.setRightToLeftReading(isRightToLeftReading)
            if pendingRestoreCFI != nil {
                readerStatusMessage = "Restoring location..."
            } else {
                readerStatusMessage = "Paginating..."
            }
        } catch {
            Log.shared.error("Failed to open library EPUB: \(error.localizedDescription)")
            readerStatusMessage = nil
        }
    }

    nonisolated private static func loadAndEscapeBase64(fileURL: URL) async throws -> String {
        try await Task.detached(priority: .userInitiated) {
            let data = try Data(contentsOf: fileURL)
            let encoded = data.base64EncodedString()
            return encoded.replacingOccurrences(of: "'", with: "\\'")
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
            self?.handleLocationsSnapshot(totalLocations: totalLocations, serializedLocations: serializedLocations)
        }

        bridge.onWordCountSample = { [weak self] counts in
            self?.handleWordCountSample(counts)
        }

        bridge.onChapterWordCount = { [weak self] index, count in
            self?.handleChapterWordCount(index: index, count: count)
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

    func handleLocationsSnapshot(totalLocations: Int, serializedLocations: String?) {
        pageController.updateTotalLocationCount(totalLocations)
        areLocationsReady = totalLocations > 0
        if totalLocations > 0, isReaderContentReady {
            readerStatusMessage = nil
        }
        persistLocationsCache(serializedLocations)
    }

    func handleWordCountSample(_ counts: [Int]) {
        let validCounts = counts.filter { $0 > 0 }
        guard !validCounts.isEmpty else {
            return
        }
        let sum = validCounts.reduce(0, +)
        averageWordsPerChapter = max(1, sum / validCounts.count)
    }

    func handleChapterWordCount(index: Int, count: Int) {
        guard count > 0 else {
            return
        }
        wordCountsBySpineIndex[index] = count
        updateMinutesRemaining(characterOffset: pageController.currentCharacterOffset)
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
            if currentSpineIndex != matchedIndex {
                currentSpineIndex = matchedIndex
                requestCurrentChapterWordCount()
            } else {
                currentSpineIndex = matchedIndex
            }
        }
    }

    private func requestCurrentChapterWordCount() {
        guard currentSpineIndex >= 0 else {
            return
        }
        pageCurlController?.requestChapterWordCount(currentSpineIndex)
    }

    private func updateMinutesRemaining(characterOffset: Int64) {
        let chapterWords = estimatedWordsForCurrentChapter()
        guard chapterWords > 0 else {
            minutesRemainingInChapter = 0
            return
        }

        let estimatedWordsRead = max(0, Int(characterOffset) / 5)
        let wordsRemaining = max(chapterWords - estimatedWordsRead, 0)
        let wpm = max(personalizedWPM, 120)
        let minutes = Int(ceil(Double(wordsRemaining) / Double(wpm)))
        minutesRemainingInChapter = max(minutes, 1)
    }

    private func estimatedWordsForCurrentChapter() -> Int {
        if let chapterWords = wordCountsBySpineIndex[currentSpineIndex], chapterWords > 0 {
            return chapterWords
        }
        return averageWordsPerChapter
    }

    private func loadPersonalizedReadingSpeed() {
        let defaultsKey = readingSpeedDefaultsKeyForCurrentBook()
        let storedWPM = UserDefaults.standard.integer(forKey: defaultsKey)
        personalizedWPM = storedWPM > 0 ? storedWPM : 238
    }

    private func readingSpeedDefaultsKeyForCurrentBook() -> String {
        if let initialBookID {
            return "reader.wpm.book.\(initialBookID.uuidString.lowercased())"
        }
        if let identifier = book?.identifier, !identifier.isEmpty {
            return "reader.wpm.book.\(identifier)"
        }
        return "reader.wpm.book.unknown"
    }

    private static func isRightToLeftLanguage(_ language: String) -> Bool {
        let normalized = language
            .lowercased()
            .split(whereSeparator: { $0 == "-" || $0 == "_" })
            .first
            .map(String.init) ?? ""
        return ["ar", "fa", "he", "iw", "ur", "yi"].contains(normalized)
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
