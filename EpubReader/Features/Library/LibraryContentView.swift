import SwiftUI

struct LibraryContentView<ContextActions: View>: View {

    let books: [Book]
    let displayMode: LibraryViewModel.DisplayMode
    let onSelectBook: (Book) -> Void
    @ViewBuilder let contextActions: (Book) -> ContextActions

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Group {
            switch displayMode {
            case .grid:
                gridContent
            case .list:
                listContent
            }
        }
        .animation(reduceMotion ? nil : AppMotion.layout, value: displayMode)
    }

    private var gridContent: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: AppSpacing.lg) {
                ForEach(books, id: \.objectID) { book in
                    BookGridCell(book: book)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onSelectBook(book)
                        }
                        .contextMenu {
                            contextActions(book)
                        }
                }
            }
            .padding(AppSpacing.md)
        }
    }

    private var listContent: some View {
        List(books, id: \.objectID) { book in
            BookListCell(book: book)
                .contentShape(Rectangle())
                .onTapGesture {
                    onSelectBook(book)
                }
                .contextMenu {
                    contextActions(book)
                }
        }
        .listStyle(.plain)
    }

    private var gridColumns: [GridItem] {
        [
            GridItem(.adaptive(minimum: 132, maximum: 190), spacing: AppSpacing.lg)
        ]
    }
}
