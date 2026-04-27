import CoreData
import Foundation

@MainActor
final class HighlightManager {
    private let persistenceController: PersistenceController

    init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
    }

    func create(
        cfiRange: String,
        cfiStart: String,
        spineHref: String,
        color: HighlightColor,
        text: String,
        bookID: UUID
    ) async -> HighlightSnapshot? {
        let id = UUID()
        let colorName = color.rawValue
        let createdAt = Date()
        let context = persistenceController.backgroundContext()

        return await context.perform {
            do {
                guard let entity = NSEntityDescription.entity(forEntityName: "Highlight", in: context) else {
                    Log.shared.error("Unable to create highlight: Highlight entity missing")
                    return nil
                }

                let highlight = Highlight(entity: entity, insertInto: context)
                highlight.id = id
                highlight.bookID = bookID
                highlight.cfiRange = cfiRange
                highlight.cfiStart = cfiStart
                highlight.spineHref = spineHref
                highlight.colorName = colorName
                highlight.selectedText = text
                highlight.createdAt = createdAt
                highlight.updatedAt = createdAt

                try context.saveIfNeeded()
                return Self.snapshot(from: highlight)
            } catch {
                context.rollback()
                Log.shared.error("Unable to create highlight: \(error.localizedDescription)")
                return nil
            }
        }
    }

    func fetchForChapter(spineHref: String, bookID: UUID) async -> [Highlight] {
        let request = NSFetchRequest<Highlight>(entityName: "Highlight")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "bookID == %@", bookID as CVarArg),
            NSPredicate(format: "spineHref == %@", spineHref)
        ])
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: true),
            NSSortDescriptor(key: "cfiStart", ascending: true)
        ]

        do {
            return try persistenceController.viewContext.fetch(request)
        } catch {
            Log.shared.error("Unable to fetch highlights for chapter: \(error.localizedDescription)")
            return []
        }
    }

    func delete(id: UUID) async {
        let context = persistenceController.backgroundContext()

        await context.perform {
            do {
                let request = NSFetchRequest<Highlight>(entityName: "Highlight")
                request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                request.fetchLimit = 1

                guard let highlight = try context.fetch(request).first else {
                    Log.shared.debug("Skipping highlight delete: id \(id.uuidString) not found")
                    return
                }

                context.delete(highlight)
                try context.saveIfNeeded()
            } catch {
                context.rollback()
                Log.shared.error("Unable to delete highlight: \(error.localizedDescription)")
            }
        }
    }

    func updateColor(id: UUID, color: HighlightColor) async -> HighlightSnapshot? {
        let context = persistenceController.backgroundContext()

        return await context.perform {
            do {
                let request = NSFetchRequest<Highlight>(entityName: "Highlight")
                request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                request.fetchLimit = 1

                guard let highlight = try context.fetch(request).first else {
                    Log.shared.debug("Skipping highlight color update: id \(id.uuidString) not found")
                    return nil
                }

                highlight.colorName = color.rawValue
                highlight.updatedAt = Date()
                try context.saveIfNeeded()
                return Self.snapshot(from: highlight)
            } catch {
                context.rollback()
                Log.shared.error("Unable to update highlight color: \(error.localizedDescription)")
                return nil
            }
        }
    }

    func snapshotsForChapter(spineHref: String, bookID: UUID) async -> [HighlightSnapshot] {
        let context = persistenceController.backgroundContext()

        return await context.perform {
            let request = NSFetchRequest<Highlight>(entityName: "Highlight")
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "bookID == %@", bookID as CVarArg),
                NSPredicate(format: "spineHref == %@", spineHref)
            ])
            request.sortDescriptors = [
                NSSortDescriptor(key: "createdAt", ascending: true),
                NSSortDescriptor(key: "cfiStart", ascending: true)
            ]

            do {
                return try context.fetch(request).compactMap(Self.snapshot(from:))
            } catch {
                Log.shared.error("Unable to fetch highlight snapshots for chapter: \(error.localizedDescription)")
                return []
            }
        }
    }

    func snapshot(id: UUID) async -> HighlightSnapshot? {
        let context = persistenceController.backgroundContext()

        return await context.perform {
            let request = NSFetchRequest<Highlight>(entityName: "Highlight")
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.fetchLimit = 1

            do {
                guard let highlight = try context.fetch(request).first else {
                    return nil
                }
                return Self.snapshot(from: highlight)
            } catch {
                Log.shared.error("Unable to fetch highlight snapshot: \(error.localizedDescription)")
                return nil
            }
        }
    }

    private nonisolated static func snapshot(from highlight: Highlight) -> HighlightSnapshot? {
        guard let id = highlight.id,
              let cfiRange = highlight.cfiRange,
              let cfiStart = highlight.cfiStart,
              let spineHref = highlight.spineHref,
              let colorName = highlight.colorName,
              let selectedText = highlight.selectedText
        else {
            return nil
        }

        return HighlightSnapshot(
            id: id,
            cfiRange: cfiRange,
            cfiStart: cfiStart,
            spineHref: spineHref,
            colorName: colorName,
            selectedText: selectedText,
            noteText: highlight.noteText
        )
    }
}

private extension NSManagedObjectContext {
    func saveIfNeeded() throws {
        guard hasChanges else {
            return
        }
        try save()
    }
}
