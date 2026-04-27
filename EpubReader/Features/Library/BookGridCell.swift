import CoreData
import SwiftUI

public struct BookGridCell: View {

    private enum Constants {
        static let maxMetadataWidth: CGFloat = 190
    }

    private let book: Book

    public init(book: Book) {
        self.book = book
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            BookCoverView(book: book)

            Text(book.title ?? "Untitled")
                .font(.caption.weight(.medium))
                .lineLimit(2)
                .frame(maxWidth: Constants.maxMetadataWidth, alignment: .leading)

            Text(book.author ?? "Unknown Author")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .frame(maxWidth: Constants.maxMetadataWidth, alignment: .leading)

            BookProgressIndicator(percentage: readingPercentage)
                .frame(maxWidth: Constants.maxMetadataWidth)
        }
        .frame(maxWidth: Constants.maxMetadataWidth, alignment: .leading)
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

        return result.clamped(to: 0...1)
    }
}
