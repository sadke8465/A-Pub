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
    private let fetchedResultsController: NSFetchedResultsController<Book>

    private var context: NSManagedObjectContext {
        fetchedResultsController.managedObjectContext
    }

    public init(
        context: NSManagedObjectContext,
        importer: FileImporter = FileImporter()
    ) {
        self.importer = importer

        let request = Book.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "importedAt", ascending: false)]
        request.predicate = NSPredicate(format: "isDeleted == NO")

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
        guard let entity = NSEntityDescription.entity(forEntityName: "Shelf", in: context) else {
            Log.shared.error("Unable to create shelf: Shelf entity missing")
            return
        }

        let shelf = Shelf(entity: entity, insertInto: context)
        shelf.id = UUID()
        shelf.name = name
        shelf.order = Int64(shelves.count)

        saveContext(logMessage: "Unable to create shelf")
        refreshShelves()
        selectedShelfID = shelf.id
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

        let existingRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShelfMembership")
        existingRequest.fetchLimit = 1
        existingRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "bookID == %@", bookID as CVarArg),
            NSPredicate(format: "shelfID == %@", shelfID as CVarArg)
        ])

        do {
            let exists = try context.count(for: existingRequest) > 0
            guard !exists else {
                return
            }
        } catch {
            Log.shared.error("Unable to check existing membership: \(error.localizedDescription)")
            return
        }

        guard let entity = NSEntityDescription.entity(forEntityName: "ShelfMembership", in: context) else {
            Log.shared.error("Unable to create membership: ShelfMembership entity missing")
            return
        }

        let membership = ShelfMembership(entity: entity, insertInto: context)
        membership.bookID = bookID
        membership.shelfID = shelfID
        membership.book = book
        membership.shelf = shelf

        saveContext(logMessage: "Unable to add book to shelf")
    }

    public func markBookFinished(_ book: Book) {
        guard let bookID = book.value(forKey: "id") as? UUID else {
            Log.shared.error("Unable to mark book as finished: missing book ID")
            return
        }

        let request = NSFetchRequest<ReadingProgress>(entityName: "ReadingProgress")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "bookID == %@", bookID as CVarArg)

        do {
            let progress = try context.fetch(request).first ?? makeReadingProgress(bookID: bookID)
            progress.percentage = 1
            progress.updatedAt = Date()
            saveContext(logMessage: "Unable to mark book as finished")
        } catch {
            Log.shared.error("Unable to mark book as finished: \(error.localizedDescription)")
        }
    }

    public func softDelete(_ book: Book) {
        book.isDeleted = true
        book.deletedAt = Date()
        saveContext(logMessage: "Unable to delete book")
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

    private func makeReadingProgress(bookID: UUID) -> ReadingProgress {
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

    private func saveContext(logMessage: String) {
        guard context.hasChanges else {
            return
        }

        do {
            try context.save()
            performFetch()
        } catch {
            Log.shared.error("\(logMessage): \(error.localizedDescription)")
            context.rollback()
        }
    }
}

extension LibraryViewModel: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        books = fetchedResultsController.fetchedObjects ?? []
    }
}
