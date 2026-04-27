import Combine
import CoreData
import Foundation

@MainActor
public final class ReaderViewModel: ObservableObject {

    @Published public var book: EPUBBook?
    @Published public var isLoading = false
    @Published public var currentCFI: String = ""
    @Published public var percentage: Double = 0
    @Published public var isOverlayVisible = false

    @Published public var bookFileURL: URL?
    @Published public var legacyEscapedBase64Book: String = ""
    @Published public var bridge = EPUBBridge()
    @Published public var currentSpineIndex = 0
    @Published public var minutesRemainingInChapter = 0
    @Published public var lastJavaScriptExecutionError: String?
    @Published public var recoveryMessage: String?

    let pageController = PageController()
    let appearance: ReaderAppearance

    private let importer: FileImporter
    private let highlightManager: HighlightManager
    private let initialBookFileURL: URL?
    private let initialBookID: UUID?
    private var didAttemptInitialLoad = false
    private var pendingRestoreCFI: String?
    private var needsLocationsSnapshotAfterReflow = false
    private let allowLegacyBase64Fallback = true
    private var jsGuardBlockedCount = 0
    private var wordCountsBySpineIndex: [Int: Int] = [:]
    private var averageWordsPerChapter: Int = 0
    private var personalizedWPM: Int = 238

    init(
        importer: FileImporter = FileImporter(),
        highlightManager: HighlightManager = HighlightManager(),
        initialBookFileURL: URL? = nil,
        initialBookID: UUID? = nil,
        appearance: ReaderAppearance = ReaderAppearance()
    ) {
        self.importer = importer
        self.highlightManager = highlightManager
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
                legacyEscapedBase64Book = result.2 ?? ""
                bookFileURL = result.1
                book = result.0
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
        loadPersonalizedReadingSpeed()
        requestCurrentChapterWordCount()

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

        updateMinutesRemaining(characterOffset: characterOffset)
    }


    func handleAppearanceChange() {
        pageController.invalidatePaginationMetricsForReflow()
        needsLocationsSnapshotAfterReflow = true
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

    func createHighlight(
        from selection: ReaderTextSelection,
        color: HighlightColor,
        spineHref: String
    ) async -> HighlightSnapshot? {
        guard let bookID = activeBookID else {
            Log.shared.error("Unable to create highlight: no active library book id")
            return nil
        }

        let cfiRange = selection.cfiRange.trimmingCharacters(in: .whitespacesAndNewlines)
        let selectedText = selection.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cfiRange.isEmpty, selectedText.count >= 2 else {
            Log.shared.error("Unable to create highlight: invalid selection")
            return nil
        }

        let resolvedSpineHref = spineHref.isEmpty ? pageController.currentSpineHref : spineHref
        guard !resolvedSpineHref.isEmpty else {
            Log.shared.error("Unable to create highlight: missing spine href")
            return nil
        }

        let cfiStart = currentCFI.isEmpty ? cfiRange : currentCFI
        return await highlightManager.create(
            cfiRange: cfiRange,
            cfiStart: cfiStart,
            spineHref: resolvedSpineHref,
            color: color,
            text: selectedText,
            bookID: bookID
        )
    }

    func highlightsJSON(for spineHref: String) async -> String? {
        guard let bookID = activeBookID else {
            Log.shared.error("Unable to restore highlights: no active library book id")
            return nil
        }

        let normalizedSpineHref = normalizeSpineHref(spineHref)
        guard !normalizedSpineHref.isEmpty else {
            return nil
        }

        let snapshots = await highlightManager.snapshotsForChapter(
            spineHref: normalizedSpineHref,
            bookID: bookID
        )
        let payloads = snapshots.map(\.renderPayload)

        do {
            let data = try JSONEncoder().encode(payloads)
            return String(decoding: data, as: UTF8.self)
        } catch {
            Log.shared.error("Unable to encode highlight payloads: \(error.localizedDescription)")
            return nil
        }
    }

    func highlightSnapshot(idString: String) async -> HighlightSnapshot? {
        guard let id = UUID(uuidString: idString) else {
            Log.shared.error("Unable to fetch highlight: invalid id \(idString)")
            return nil
        }
        return await highlightManager.snapshot(id: id)
    }

    func deleteHighlight(_ highlight: HighlightSnapshot) async -> Bool {
        await highlightManager.delete(id: highlight.id)
        return await highlightManager.snapshot(id: highlight.id) == nil
    }

    func updateHighlightColor(
        _ highlight: HighlightSnapshot,
        color: HighlightColor
    ) async -> HighlightSnapshot? {
        await highlightManager.updateColor(id: highlight.id, color: color)
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
            let escapedBase64Book = allowLegacyBase64Fallback
                ? (try await Self.loadAndEscapeBase64(fileURL: fileURL))
                : ""

            legacyEscapedBase64Book = escapedBase64Book
            bookFileURL = fileURL
            book = parsedBook
        } catch {
            Log.shared.error("Failed to open library EPUB: \(error.localizedDescription)")
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
            guard let self else { return }
            self.pageController.updateTotalLocationCount(totalLocations)
            self.persistLocationsCache(serializedLocations)
        }

        bridge.onWordCountSample = { [weak self] counts in
            guard let self else { return }
            let validCounts = counts.filter { $0 > 0 }
            guard !validCounts.isEmpty else {
                return
            }
            let sum = validCounts.reduce(0, +)
            self.averageWordsPerChapter = max(1, sum / validCounts.count)
        }

        bridge.onChapterWordCount = { [weak self] index, count in
            guard let self else { return }
            guard count > 0 else {
                return
            }
            self.wordCountsBySpineIndex[index] = count
            self.updateMinutesRemaining(characterOffset: self.pageController.currentCharacterOffset)
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
        bridge.callJS("requestChapterWordCount(\(currentSpineIndex))")
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

    private var activeBookID: UUID? {
        initialBookID ?? pageController.currentBookID
    }

    private func normalizeSpineHref(_ spineHref: String) -> String {
        if !spineHref.isEmpty {
            return spineHref
        }
        return pageController.currentSpineHref
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
