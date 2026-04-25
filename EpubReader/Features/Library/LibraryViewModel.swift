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
    }

    public var filteredBooks: [Book] {
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            return books
        }

        return books.filter { book in
            let title = book.title ?? ""
            let author = book.author ?? ""
            return title.localizedCaseInsensitiveContains(query) || author.localizedCaseInsensitiveContains(query)
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
}

extension LibraryViewModel: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        books = fetchedResultsController.fetchedObjects ?? []
    }
}
