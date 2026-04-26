import Combine
import CoreData
import Foundation

@MainActor
public final class LibraryViewModel: NSObject, ObservableObject {

    public enum DisplayMode: String, CaseIterable {
        case grid
        case list
    }

    public enum SortOrder: String, CaseIterable {
        case title
        case author
        case lastRead
        case dateAdded
    }

    @Published public private(set) var books: [Book] = []
    @Published public private(set) var shelves: [Shelf] = []
    @Published public var selectedShelfID: UUID?
    @Published public var displayMode: DisplayMode = .grid
    @Published public var sortOrder: SortOrder = .dateAdded {
        didSet {
            updateSortOrder()
            performFetch()
        }
    }
    @Published public var searchQuery = "" {
        didSet {
            objectWillChange.send()
        }
    }
    @Published public var isImporting = false

    private let importer: FileImporter
    private let persistenceController: PersistenceController
    private let fetchedResultsController: NSFetchedResultsController<Book>

    private var context: NSManagedObjectContext {
        fetchedResultsController.managedObjectContext
    }

    init(
        context: NSManagedObjectContext,
        importer: FileImporter = FileImporter(),
        persistenceController: PersistenceController = .shared
    ) {
        self.importer = importer
        self.persistenceController = persistenceController

        let request = Book.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "importedAt", ascending: false)]
        request.predicate = NSPredicate(format: "isSoftDeleted == NO")

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        super.init()

        fetchedResultsController.delegate = self
        performFetch()
        refreshShelves()
    }

    public var filteredBooks: [Book] {
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)

        return books.filter { book in
            let matchesQuery: Bool
            if query.isEmpty {
                matchesQuery = true
            } else {
                let title = book.title ?? ""
                let author = book.author ?? ""
                matchesQuery = title.localizedCaseInsensitiveContains(query) || author.localizedCaseInsensitiveContains(query)
            }

            guard matchesQuery else {
                return false
            }

            guard let selectedShelfID else {
                return true
            }

            guard let memberships = book.value(forKey: "memberships") as? Set<NSManagedObject> else {
                return false
            }

            return memberships.contains { membership in
                membership.value(forKey: "shelfID") as? UUID == selectedShelfID
            }
        }
    }

    public func importBooks() {
        guard !isImporting else {
            return
        }

        isImporting = true

        Task {
            defer {
                isImporting = false
            }

            do {
                let stream = try await importer.importEPUB()
                for await progress in stream {
                    switch progress {
                    case .processing, .done, .skipped:
                        continue
                    case .failed(_, let error):
                        Log.shared.error("Book import failed: \(error.localizedDescription)")
                    }
                }
            } catch is CancellationError {
                Log.shared.info("User cancelled book import")
            } catch {
                Log.shared.error("Unable to start import: \(error.localizedDescription)")
            }
        }
    }

    public func createShelf(named name: String) {
        let shelfID = UUID()
        let nextOrder = Int64(shelves.count)

        performBackgroundWrite(logMessage: "Unable to create shelf", completion: { [weak self] in
            self?.refreshShelves()
        }) { backgroundContext in
            guard let entity = NSEntityDescription.entity(forEntityName: "Shelf", in: backgroundContext) else {
                Log.shared.error("Unable to create shelf: Shelf entity missing")
                return
            }

            let shelf = Shelf(entity: entity, insertInto: backgroundContext)
            shelf.id = shelfID
            shelf.name = name
            shelf.order = nextOrder
        }

        selectedShelfID = shelfID
    }

    public func addBook(_ book: Book, to shelf: Shelf) {
        guard let bookID = book.value(forKey: "id") as? UUID else {
            Log.shared.error("Unable to add book to shelf: missing book ID")
            return
        }

        guard let shelfID = shelf.value(forKey: "id") as? UUID else {
            Log.shared.error("Unable to add book to shelf: missing shelf ID")
            return
        }

        let bookObjectID = book.objectID
        let shelfObjectID = shelf.objectID

        performBackgroundWrite(logMessage: "Unable to add book to shelf") { backgroundContext in
            let existingRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShelfMembership")
            existingRequest.fetchLimit = 1
            existingRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "bookID == %@", bookID as CVarArg),
                NSPredicate(format: "shelfID == %@", shelfID as CVarArg)
            ])

            do {
                let exists = try backgroundContext.count(for: existingRequest) > 0
                guard !exists else {
                    return
                }
            } catch {
                Log.shared.error("Unable to check existing membership: \(error.localizedDescription)")
                return
            }

            guard let entity = NSEntityDescription.entity(forEntityName: "ShelfMembership", in: backgroundContext) else {
                Log.shared.error("Unable to create membership: ShelfMembership entity missing")
                return
            }

            guard let backgroundBook = try? backgroundContext.existingObject(with: bookObjectID) as? Book,
                  let backgroundShelf = try? backgroundContext.existingObject(with: shelfObjectID) as? Shelf
            else {
                Log.shared.error("Unable to add book to shelf: object lookup failed")
                return
            }

            let membership = ShelfMembership(entity: entity, insertInto: backgroundContext)
            membership.bookID = bookID
            membership.shelfID = shelfID
            membership.book = backgroundBook
            membership.shelf = backgroundShelf
        }
    }

    public func markBookFinished(_ book: Book) {
        guard let bookID = book.value(forKey: "id") as? UUID else {
            Log.shared.error("Unable to mark book as finished: missing book ID")
            return
        }

        performBackgroundWrite(logMessage: "Unable to mark book as finished") { backgroundContext in
            let request = NSFetchRequest<ReadingProgress>(entityName: "ReadingProgress")
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "bookID == %@", bookID as CVarArg)

            do {
                let progress = try backgroundContext.fetch(request).first ?? Self.makeReadingProgress(bookID: bookID, in: backgroundContext)
                progress.percentage = 1
                progress.updatedAt = Date()
            } catch {
                Log.shared.error("Unable to mark book as finished: \(error.localizedDescription)")
            }
        }
    }

    public func softDelete(_ book: Book) {
        guard let bookID = book.value(forKey: "id") as? UUID else {
            Log.shared.error("Unable to delete book: missing book ID")
            return
        }

        performBackgroundWrite(logMessage: "Unable to delete book") { backgroundContext in
            let request = NSFetchRequest<Book>(entityName: "Book")
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "id == %@", bookID as CVarArg)

            guard let persistedBook = try backgroundContext.fetch(request).first else {
                Log.shared.error("Unable to delete book: failed to find persisted Book")
                return
            }

            persistedBook.setValue(true, forKey: "isSoftDeleted")
            persistedBook.deletedAt = Date()
        }
    }

    public func refreshShelves() {
        let request = NSFetchRequest<Shelf>(entityName: "Shelf")
        request.sortDescriptors = [
            NSSortDescriptor(key: "order", ascending: true),
            NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        ]

        do {
            shelves = try context.fetch(request)
        } catch {
            Log.shared.error("Unable to fetch shelves: \(error.localizedDescription)")
            shelves = []
        }
    }

    private func performFetch() {
        do {
            try fetchedResultsController.performFetch()
            books = fetchedResultsController.fetchedObjects ?? []
        } catch {
            Log.shared.error("Library fetch failed: \(error.localizedDescription)")
            books = []
        }
    }

    private func updateSortOrder() {
        switch sortOrder {
        case .title:
            fetchedResultsController.fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
            ]
        case .author:
            fetchedResultsController.fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "author", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
            ]
        case .lastRead:
            fetchedResultsController.fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "importedAt", ascending: false)
            ]
        case .dateAdded:
            fetchedResultsController.fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "importedAt", ascending: false)
            ]
        }
    }

    nonisolated private static func makeReadingProgress(bookID: UUID, in context: NSManagedObjectContext) -> ReadingProgress {
        guard let entity = NSEntityDescription.entity(forEntityName: "ReadingProgress", in: context) else {
            let fallback = ReadingProgress(context: context)
            fallback.id = UUID()
            fallback.bookID = bookID
            fallback.percentage = 0
            Log.shared.error("ReadingProgress entity missing; using fallback initializer")
            return fallback
        }

        let progress = ReadingProgress(entity: entity, insertInto: context)
        progress.id = UUID()
        progress.bookID = bookID
        progress.percentage = 0
        return progress
    }

    private func performBackgroundWrite(
        logMessage: String,
        completion: (@MainActor @Sendable () -> Void)? = nil,
        operation: @escaping @Sendable (NSManagedObjectContext) throws -> Void
    ) {
        let backgroundContext = persistenceController.backgroundContext()
        backgroundContext.perform {
            do {
                try operation(backgroundContext)
                if backgroundContext.hasChanges {
                    try backgroundContext.save()
                }
                if let completion {
                    Task { @MainActor in
                        completion()
                    }
                }
            } catch {
                backgroundContext.rollback()
                Log.shared.error("\(logMessage): \(error.localizedDescription)")
            }
        }
    }
}

extension LibraryViewModel: NSFetchedResultsControllerDelegate {
    nonisolated public func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        Task { @MainActor [weak self] in
            self?.books = self?.fetchedResultsController.fetchedObjects ?? []
        }
    }
}
