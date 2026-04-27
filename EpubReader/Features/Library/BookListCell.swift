import CoreData
import SwiftUI

public struct BookListCell: View {

    private enum Constants {
        static let thumbnailWidth: CGFloat = AppCover.listWidth
    }

    private let book: Book

    public init(book: Book) {
        self.book = book
    }

    public var body: some View {
        HStack(spacing: 12) {
            BookCoverView(book: book)
                .frame(width: Constants.thumbnailWidth, height: Constants.thumbnailWidth / AppCover.aspectRatio)

            VStack(alignment: .leading, spacing: 4) {
                Text(book.title ?? "Untitled")
                    .font(.body.weight(.semibold))
                    .lineLimit(2)

                Text(book.author ?? "Unknown Author")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                BookProgressIndicator(percentage: readingPercentage)
                    .frame(maxWidth: 180)
            }

            Spacer(minLength: 12)

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
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
