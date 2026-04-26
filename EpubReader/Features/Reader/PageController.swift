import Combine
import CoreData
import Foundation
import UIKit

/// Tracks the reader's current position and persists it to Core Data.
///
/// Call ``onRelocated(cfi:pct:spineHref:characterOffset:contextSnippet:atEnd:)`` on every epub.js `relocated` event.
/// Saves are debounced 500 ms so rapid page turns don't hammer Core Data.
@MainActor
final class PageController: ObservableObject {

    @Published var currentCFI: String = ""
    @Published var percentageInBook: Double = 0
    @Published var currentSpineIndex: Int = 0
    @Published var currentSpineHref: String = ""
    @Published var currentCharacterOffset: Int64 = 0
    @Published var currentContextSnippet: String = ""
    @Published var totalLocationCount: Int = 0

    /// Set this before the first ``onRelocated`` call so the debounced save
    /// knows which book to update.
    var currentBookID: UUID?

    private var saveDebounceTask: Task<Void, Never>?

    // MARK: - Public API

    func invalidatePaginationMetricsForReflow() {
        totalLocationCount = 0
    }

    func updateTotalLocationCount(_ count: Int) {
        totalLocationCount = max(0, count)
    }

    func onRelocated(
        cfi: String,
        pct: Double,
        spineHref: String,
        characterOffset: Int64,
        contextSnippet: String,
        atEnd: Bool
    ) {
        currentCFI = cfi
        percentageInBook = pct
        currentSpineHref = spineHref
        currentCharacterOffset = characterOffset
        currentContextSnippet = contextSnippet

        guard let bookID = currentBookID else { return }

        saveDebounceTask?.cancel()
        saveDebounceTask = Task { [weak self] in
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
            } catch {
                return
            }
            await self?.saveCFI(for: bookID)
        }
    }

    /// Upserts a ``ReadingProgress`` record for the given book in a background context.
    func saveCFI(for bookID: UUID) async {
        let cfi = currentCFI
        let pct = percentageInBook
        let spineHref = currentSpineHref
        let characterOffset = currentCharacterOffset
        let contextSnippet = currentContextSnippet
        let deviceID = UIDevice.current.identifierForVendor?.uuidString
        let context = PersistenceController.shared.backgroundContext()

        await context.perform {
            let request = NSFetchRequest<NSManagedObject>(entityName: "ReadingProgress")
            request.predicate = NSPredicate(format: "bookID == %@", bookID as CVarArg)
            request.fetchLimit = 1

            do {
                let results = try context.fetch(request)
                let progress: NSManagedObject
                if let existing = results.first {
                    progress = existing
                } else {
                    guard let entity = NSEntityDescription.entity(
                        forEntityName: "ReadingProgress",
                        in: context
                    ) else { return }
                    progress = NSManagedObject(entity: entity, insertInto: context)
                    progress.setValue(UUID(), forKey: "id")
                    progress.setValue(bookID, forKey: "bookID")
                    progress.setValue(deviceID, forKey: "deviceID")
                }

                progress.setValue(cfi, forKey: "cfi")
                progress.setValue(spineHref, forKey: "spineHref")
                progress.setValue(characterOffset, forKey: "characterOffset")
                progress.setValue(contextSnippet, forKey: "contextSnippet")
                progress.setValue(pct, forKey: "percentage")
                progress.setValue(Date(), forKey: "updatedAt")

                try context.save()
            } catch {
                Log.shared.error("PageController.saveCFI failed: \(error.localizedDescription)")
            }
        }
    }

    /// Returns the last saved CFI for the given book, or `nil` if none exists.
    func restoreCFI(for bookID: UUID) async -> String? {
        let context = PersistenceController.shared.backgroundContext()
        return await context.perform {
            let request = NSFetchRequest<NSManagedObject>(entityName: "ReadingProgress")
            request.predicate = NSPredicate(format: "bookID == %@", bookID as CVarArg)
            request.fetchLimit = 1

            do {
                return try context.fetch(request).first?.value(forKey: "cfi") as? String
            } catch {
                Log.shared.error("PageController.restoreCFI failed: \(error.localizedDescription)")
                return nil
            }
        }
    }
}
