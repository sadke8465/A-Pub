import SwiftUI

struct BookCoverView: View {

    let book: Book

    var body: some View {
        Group {
            if let coverPath = book.coverImagePath,
               let image = UIImage(contentsOfFile: coverPath) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholderCover
            }
        }
        .aspectRatio(AppCover.aspectRatio, contentMode: .fill)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.cover, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    }

    private var placeholderCover: some View {
        RoundedRectangle(cornerRadius: AppRadius.cover, style: .continuous)
            .fill(Color(.secondarySystemFill))
            .overlay {
                VStack(spacing: AppSpacing.xs) {
                    Image(systemName: "book.closed")
                        .font(.title2)
                    Text(book.title ?? "Untitled")
                        .font(.footnote.weight(.semibold))
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .padding(.horizontal, AppSpacing.xs)
                }
                .foregroundStyle(.secondary)
            }
    }
}
