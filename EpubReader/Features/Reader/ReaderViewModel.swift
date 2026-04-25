import Foundation

@MainActor
public final class ReaderViewModel: ObservableObject {

    @Published public var book: EPUBBook?
    @Published public var isLoading = false
    @Published public var currentCFI: String = ""
    @Published public var percentage: Double = 0
    @Published public var isOverlayVisible = true

    public var base64Book: String = ""
    public var bridge = EPUBBridge()
    public var currentSpineIndex = 0

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
        bridge.onRelocated = { [weak self] cfi, pct in
            guard let self else { return }
            self.currentCFI = cfi
            self.percentage = pct
        }

        bridge.onBookReady = {
            Log.shared.info("EPUB book ready")
        }
    }
}
