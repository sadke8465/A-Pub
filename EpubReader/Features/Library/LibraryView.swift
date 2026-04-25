import SwiftUI

public struct LibraryView: View {

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @StateObject private var viewModel: LibraryViewModel

    @State private var pendingDeleteBook: Book?
    @State private var metadataEditBook: Book?

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
                    if viewModel.filteredBooks.isEmpty {
                        emptyState
                    } else {
                        content
                    }
                }
            }
            .navigationTitle("Library")
            .searchable(text: $viewModel.searchQuery, prompt: "Search by title or author")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    sortMenu
                    displayToggle
                    importButton
                }
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
            .sheet(item: $metadataEditBook) { book in
                MetadataEditView(book: book)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "books.vertical")
                .font(.system(size: 54, weight: .light))
                .foregroundStyle(.secondary)

            Text("Import your first book")
                .font(.headline)

            Button {
                viewModel.importBooks()
            } label: {
                Label("Import EPUB", systemImage: "square.and.arrow.down")
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.displayMode {
        case .grid:
            ScrollView {
                LazyVGrid(columns: gridColumns, spacing: 16) {
                    ForEach(viewModel.filteredBooks, id: \.objectID) { book in
                        BookGridCell(book: book)
                            .contextMenu {
                                bookContextActions(for: book)
                            }
                    }
                }
                .padding()
            }
        case .list:
            List(viewModel.filteredBooks, id: \.objectID) { book in
                BookListCell(book: book)
                    .contextMenu {
                        bookContextActions(for: book)
                    }
            }
            .listStyle(.plain)
        }
    }

    private var gridColumns: [GridItem] {
        let count = horizontalSizeClass == .regular ? 4 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 12), count: count)
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
            metadataEditBook = book
        }

        Button("Delete from Library", systemImage: "trash", role: .destructive) {
            pendingDeleteBook = book
        }
    }

    private var sortMenu: some View {
        Menu {
            Picker("Sort by", selection: $viewModel.sortOrder) {
                Text("Title").tag(LibraryViewModel.SortOrder.title)
                Text("Author").tag(LibraryViewModel.SortOrder.author)
                Text("Last Read").tag(LibraryViewModel.SortOrder.lastRead)
                Text("Date Added").tag(LibraryViewModel.SortOrder.dateAdded)
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down.circle")
        }
        .accessibilityLabel("Sort")
    }

    private var displayToggle: some View {
        Button {
            viewModel.displayMode = viewModel.displayMode == .grid ? .list : .grid
        } label: {
            Image(systemName: viewModel.displayMode == .grid ? "list.bullet" : "square.grid.2x2")
        }
        .accessibilityLabel("Toggle display mode")
    }

    private var importButton: some View {
        Button {
            viewModel.importBooks()
        } label: {
            Label("Import", systemImage: "plus")
        }
        .disabled(viewModel.isImporting)
    }
}

private struct MetadataEditView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var author: String

    private let book: Book

    init(book: Book) {
        self.book = book
        _title = State(initialValue: book.title ?? "")
        _author = State(initialValue: book.author ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Author", text: $author)
            }
            .navigationTitle("Edit Metadata")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                        dismiss()
                    }
                }
            }
        }
    }

    private func saveChanges() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAuthor = author.trimmingCharacters(in: .whitespacesAndNewlines)

        book.title = trimmedTitle.isEmpty ? "Untitled" : trimmedTitle
        book.author = trimmedAuthor.isEmpty ? "Unknown Author" : trimmedAuthor

        guard let context = book.managedObjectContext else {
            return
        }

        do {
            try context.save()
        } catch {
            context.rollback()
            Log.shared.error("Unable to save metadata edits: \(error.localizedDescription)")
        }
    }
}

#Preview {
    LibraryView()
        .environment(\.managedObjectContext, PersistenceController.shared.viewContext)
}
