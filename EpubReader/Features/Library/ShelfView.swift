import SwiftUI

public struct ShelfView: View {

    private let shelves: [Shelf]
    @Binding private var selectedShelfID: UUID?
    private let onAddShelf: (String) -> Void

    @State private var isShowingAddShelfPrompt = false
    @State private var newShelfName = ""

    public init(
        shelves: [Shelf],
        selectedShelfID: Binding<UUID?>,
        onAddShelf: @escaping (String) -> Void
    ) {
        self.shelves = shelves
        _selectedShelfID = selectedShelfID
        self.onAddShelf = onAddShelf
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                shelfTab(title: "All Books", shelfID: nil)

                ForEach(shelves, id: \.objectID) { shelf in
                    shelfTab(title: shelf.name ?? "Untitled Shelf", shelfID: shelf.id)
                }

                Button {
                    newShelfName = ""
                    isShowingAddShelfPrompt = true
                } label: {
                    Label("Add Shelf", systemImage: "plus")
                        .font(.subheadline.weight(.medium))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
        .alert("New Shelf", isPresented: $isShowingAddShelfPrompt) {
            TextField("Shelf name", text: $newShelfName)
            Button("Create") {
                let trimmed = newShelfName.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else {
                    return
                }
                onAddShelf(trimmed)
            }
            Button("Cancel", role: .cancel) {
            }
        } message: {
            Text("Create a shelf to organize books.")
        }
    }

    private func shelfTab(title: String, shelfID: UUID?) -> some View {
        let isSelected = selectedShelfID == shelfID

        return Button {
            selectedShelfID = shelfID
        } label: {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Color.accentColor : Color.secondary.opacity(0.15), in: Capsule())
        }
        .buttonStyle(.plain)
    }
}
