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
                DisplayModeToggleIcon(displayMode: displayMode)
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

private struct DisplayModeToggleIcon: View {

    let displayMode: LibraryViewModel.DisplayMode

    var body: some View {
        ZStack {
            Image(systemName: "list.bullet")
                .opacity(displayMode == .grid ? 1 : 0)

            Image(systemName: "square.grid.2x2")
                .opacity(displayMode == .grid ? 0 : 1)
        }
        .frame(width: AppSize.toolbarControl, height: AppSize.toolbarControl)
        .transaction { transaction in
            transaction.animation = nil
        }
    }
}
