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

    private let importer: FileImporter

    public init(importer: FileImporter = FileImporter()) {
        self.importer = importer
        configureBridgeCallbacks()
    }

    public func loadFromFile() {
        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                let result = try await importer.importEPUB()
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

    public func toggleOverlay() {
        isOverlayVisible.toggle()
    }

    private func configureBridgeCallbacks() {
        bridge.onRelocated = { [weak self] cfi, pct, spineHref in
            guard let self else { return }
            self.currentCFI = cfi
            self.percentage = pct
            self.updateCurrentSpineIndex(using: spineHref)
        }

        bridge.onBookReady = {
            Log.shared.info("EPUB book ready")
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
