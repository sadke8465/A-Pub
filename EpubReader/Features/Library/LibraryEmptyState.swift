import SwiftUI

struct LibraryEmptyState: View {

    let onImport: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label("No Books", systemImage: "books.vertical")
        } description: {
            Text("Import an EPUB to begin reading.")
        } actions: {
            Button {
                onImport()
            } label: {
                Label("Import EPUB", systemImage: "square.and.arrow.down")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
