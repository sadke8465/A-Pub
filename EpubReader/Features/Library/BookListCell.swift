import CoreData
import SwiftUI

public struct BookListCell: View {

    private enum Constants {
        static let thumbnailWidth: CGFloat = 50
        static let thumbnailHeight: CGFloat = 70
        static let cornerRadius: CGFloat = 6
    }

    private let book: Book

    public init(book: Book) {
        self.book = book
    }

    public var body: some View {
        HStack(spacing: 12) {
            coverThumbnail
                .frame(width: Constants.thumbnailWidth, height: Constants.thumbnailHeight)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(book.title ?? "Untitled")
                    .font(.body.weight(.semibold))
                    .lineLimit(2)

                Text(book.author ?? "Unknown Author")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Text("\(Int(readingPercentage * 100))% read")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 12)

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }

    private var coverThumbnail: some View {
        Group {
            if let coverPath = book.coverImagePath,
               let image = UIImage(contentsOfFile: coverPath) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous)
                    .fill(placeholderColor)
                    .overlay {
                        Image(systemName: "book.closed")
                            .font(.headline)
                            .foregroundStyle(.white.opacity(0.9))
                    }
            }
        }
    }

    private var placeholderColor: Color {
        let author = book.author ?? "Unknown"
        let hash = abs(author.hashValue)
        let hue = Double(hash % 360) / 360
        return Color(hue: hue, saturation: 0.38, brightness: 0.76)
    }

    private var readingPercentage: Double {
        guard let context = book.managedObjectContext, let bookID = book.id else {
            return 0
        }

        let result = context.performAndWait { () -> Double in
            let request = NSFetchRequest<NSManagedObject>(entityName: "ReadingProgress")
            request.predicate = NSPredicate(format: "bookID == %@", bookID as CVarArg)
            request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
            request.fetchLimit = 1

            if let progress = try? context.fetch(request).first,
               let percentage = progress.value(forKey: "percentage") as? Double {
                return percentage
            }

            return 0
        }

        return min(max(result, 0), 1)
    }
}
