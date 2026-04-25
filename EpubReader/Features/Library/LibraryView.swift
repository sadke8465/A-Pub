import SwiftUI

public struct LibraryView: View {

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @StateObject private var viewModel: LibraryViewModel

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
            Group {
                if viewModel.filteredBooks.isEmpty {
                    emptyState
                } else {
                    content
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
                        VStack(alignment: .leading, spacing: 8) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.quaternary)
                                .overlay {
                                    if let coverPath = book.coverImagePath,
                                       let image = UIImage(contentsOfFile: coverPath) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    } else {
                                        Image(systemName: "book.closed")
                                            .font(.largeTitle)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .frame(height: 180)

                            Text(book.title ?? "Untitled")
                                .font(.subheadline.weight(.semibold))
                                .lineLimit(2)

                            Text(book.author ?? "Unknown Author")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
                .padding()
            }
        case .list:
            List(viewModel.filteredBooks, id: \.objectID) { book in
                VStack(alignment: .leading, spacing: 4) {
                    Text(book.title ?? "Untitled")
                        .font(.headline)
                    Text(book.author ?? "Unknown Author")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            .listStyle(.plain)
        }
    }

    private var gridColumns: [GridItem] {
        let count = horizontalSizeClass == .regular ? 4 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 12), count: count)
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

#Preview {
    LibraryView()
        .environment(\.managedObjectContext, PersistenceController.shared.viewContext)
}
