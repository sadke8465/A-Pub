import SwiftUI

struct LibraryToolbar: ToolbarContent {

    @Binding var sortOrder: LibraryViewModel.SortOrder
    @Binding var displayMode: LibraryViewModel.DisplayMode
    let isImporting: Bool
    let onImport: () -> Void

    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Menu {
                Picker("Sort by", selection: $sortOrder) {
                    Text("Title").tag(LibraryViewModel.SortOrder.title)
                    Text("Author").tag(LibraryViewModel.SortOrder.author)
                    Text("Last Read").tag(LibraryViewModel.SortOrder.lastRead)
                    Text("Date Added").tag(LibraryViewModel.SortOrder.dateAdded)
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down.circle")
                    .frame(width: AppSize.toolbarControl, height: AppSize.toolbarControl)
            }
            .accessibilityLabel("Sort")

            Button {
                displayMode = displayMode == .grid ? .list : .grid
            } label: {
                Image(systemName: displayMode == .grid ? "list.bullet" : "square.grid.2x2")
                    .frame(width: AppSize.toolbarControl, height: AppSize.toolbarControl)
            }
            .accessibilityLabel("Toggle display mode")

            Button {
                onImport()
            } label: {
                Image(systemName: "plus")
                    .frame(width: AppSize.toolbarControl, height: AppSize.toolbarControl)
            }
            .accessibilityLabel("Import EPUB")
            .disabled(isImporting)
        }
    }
}
