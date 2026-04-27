import SwiftUI

public struct LibraryView: View {

    @StateObject private var viewModel: LibraryViewModel

    @State private var pendingDeleteBook: Book?
    @State private var selectedDetailBook: Book?
    @State private var selectedEditBook: Book?
    @State private var readerLaunchRequest: ReaderLaunchRequest?

    public init(viewModel: LibraryViewModel? = nil) {
        if let viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            let context = PersistenceController.shared.viewContext
            _viewModel = StateObject(wrappedValue: LibraryViewModel(context: context))
        }
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ShelfView(
                    shelves: viewModel.shelves,
                    selectedShelfID: $viewModel.selectedShelfID,
                    onAddShelf: viewModel.createShelf(named:)
                )

                Group {
                    if viewModel.books.isEmpty {
                        LibraryEmptyState {
                            viewModel.importBooks()
                        }
                    } else {
                        LibraryContentView(
                            books: viewModel.filteredBooks,
                            displayMode: viewModel.displayMode,
                            onSelectBook: { book in
                                selectedDetailBook = book
                            },
                            contextActions: { book in
                                bookContextActions(for: book)
                            }
                        )
                    }
                }
            }
            .navigationTitle("Library")
            .searchable(text: $viewModel.searchQuery, prompt: "Search by title or author")
            .toolbar {
                LibraryToolbar(
                    sortOrder: $viewModel.sortOrder,
                    displayMode: $viewModel.displayMode,
                    isImporting: viewModel.isImporting,
                    onImport: viewModel.importBooks
                )
            }
            .overlay {
                if viewModel.isImporting {
                    ProgressView("Importing books…")
                        .padding(12)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
            }
            .confirmationDialog(
                "Delete this book from your library?",
                isPresented: Binding(
                    get: { pendingDeleteBook != nil },
                    set: { isPresented in
                        if !isPresented {
                            pendingDeleteBook = nil
                        }
                    }
                ),
                titleVisibility: .visible
            ) {
                Button("Delete from Library", role: .destructive) {
                    guard let book = pendingDeleteBook else {
                        return
                    }
                    viewModel.softDelete(book)
                    pendingDeleteBook = nil
                }
                Button("Cancel", role: .cancel) {
                    pendingDeleteBook = nil
                }
            }
            .sheet(item: $selectedDetailBook) { book in
                BookDetailView(book: book) { selectedBook in
                    launchReader(for: selectedBook)
                }
            }
            .sheet(item: $selectedEditBook) { book in
                BookDetailView(book: book, isEditMode: true) { _ in }
            }
            .navigationDestination(item: $readerLaunchRequest) { request in
                ReaderView(
                    viewModel: ReaderViewModel(
                        initialBookFileURL: request.fileURL,
                        initialBookID: request.bookID
                    )
                )
                    .navigationTitle(request.title)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    @ViewBuilder
    private func bookContextActions(for book: Book) -> some View {
        Menu("Add to Shelf") {
            if viewModel.shelves.isEmpty {
                Text("Create a shelf first")
            } else {
                ForEach(viewModel.shelves, id: \.objectID) { shelf in
                    Button(shelf.name ?? "Untitled Shelf") {
                        viewModel.addBook(book, to: shelf)
                    }
                }
            }
        }

        Button("Mark as Finished", systemImage: "checkmark.circle") {
            viewModel.markBookFinished(book)
        }

        Button("Edit Metadata", systemImage: "pencil") {
            selectedEditBook = book
        }

        Button("Delete from Library", systemImage: "trash", role: .destructive) {
            pendingDeleteBook = book
        }
    }

    private func launchReader(for book: Book) {
        guard let filePath = book.filePath,
              let fileURL = FileImporter.resolvedEPUBURL(for: filePath)
        else {
            Log.shared.error("Unable to open reader: missing or unresolvable file path")
            return
        }

        selectedDetailBook = nil
        readerLaunchRequest = ReaderLaunchRequest(
            fileURL: fileURL,
            bookID: book.id,
            title: book.title ?? "Reader"
        )
    }
}

private struct ReaderLaunchRequest: Identifiable, Hashable {
    let id = UUID()
    let fileURL: URL
    let bookID: UUID?
    let title: String
}

#Preview {
    LibraryView()
        .environment(\.managedObjectContext, PersistenceController.shared.viewContext)
}
