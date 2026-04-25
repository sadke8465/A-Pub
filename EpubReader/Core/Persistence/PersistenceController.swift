import CoreData
import Foundation

@MainActor
final class PersistenceController {
    static let shared = PersistenceController()

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EpubReader")

        container.loadPersistentStores { _, error in
            if let error {
                Log.shared.error("Failed to load persistent stores: \(error.localizedDescription)")
                fatalError("Unresolved error loading persistent store: \(error)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

#if DEBUG
        seedDebugBookIfNeeded(using: container)
#endif

        return container
    }()

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    func backgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }

    private init() {}

#if DEBUG
    private func seedDebugBookIfNeeded(using container: NSPersistentContainer) {
        let context = container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        request.fetchLimit = 1

        do {
            let existingCount = try context.count(for: request)
            guard existingCount == 0 else {
                return
            }

            guard let testEPUBURL = Bundle.main.url(forResource: "test", withExtension: "epub") else {
                Log.shared.debug("Skipping debug seed: bundled test.epub was not found")
                return
            }

            guard let entity = NSEntityDescription.entity(forEntityName: "Book", in: context) else {
                Log.shared.error("Skipping debug seed: Book entity not found")
                return
            }

            let book = NSManagedObject(entity: entity, insertInto: context)
            book.setValue(UUID(), forKey: "id")
            book.setValue("Debug Test Book", forKey: "title")
            book.setValue("EpubReader", forKey: "author")
            book.setValue(testEPUBURL.path, forKey: "filePath")
            book.setValue("en", forKey: "language")
            book.setValue(Date(), forKey: "importedAt")
            book.setValue(false, forKey: "isDeleted")

            try context.save()
            Log.shared.info("Seeded debug library with bundled test.epub")
        } catch {
            Log.shared.error("Failed to seed debug book: \(error.localizedDescription)")
        }
    }
#endif
}
