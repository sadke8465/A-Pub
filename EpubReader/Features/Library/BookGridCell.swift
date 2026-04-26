import CoreData
import SwiftUI

public struct BookGridCell: View {

    private enum Constants {
        static let coverCornerRadius: CGFloat = 6
        static let coverHeight: CGFloat = 180
        static let shadowRadius: CGFloat = 6
        static let shadowYOffset: CGFloat = 3
        static let ringSize: CGFloat = 26
        static let ringLineWidth: CGFloat = 2
    }

    private let book: Book

    public init(book: Book) {
        self.book = book
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            coverView
                .frame(height: Constants.coverHeight)
                .clipShape(RoundedRectangle(cornerRadius: Constants.coverCornerRadius, style: .continuous))
                .shadow(color: .black.opacity(0.12), radius: Constants.shadowRadius, x: 0, y: Constants.shadowYOffset)
                .overlay(alignment: .bottomTrailing) {
                    progressRing
                        .padding(8)
                }

            Text(book.title ?? "Untitled")
                .font(.caption.weight(.medium))
                .lineLimit(2)

            Text(book.author ?? "Unknown Author")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
    }

    private var coverView: some View {
        Group {
            if let coverPath = book.coverImagePath,
               let image = UIImage(contentsOfFile: coverPath) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                RoundedRectangle(cornerRadius: Constants.coverCornerRadius, style: .continuous)
                    .fill(placeholderColor)
                    .overlay {
                        Image(systemName: "book.closed.fill")
                            .font(.title3)
                            .foregroundStyle(.white.opacity(0.9))
                    }
            }
        }
    }

    private var progressRing: some View {
        let percentage = readingPercentage

        return ZStack {
            Circle()
                .stroke(.white.opacity(0.3), lineWidth: Constants.ringLineWidth)

            Circle()
                .trim(from: 0, to: min(max(percentage, 0), 1))
                .stroke(progressColor(for: percentage), style: StrokeStyle(lineWidth: Constants.ringLineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .frame(width: Constants.ringSize, height: Constants.ringSize)
        .padding(4)
        .background(.ultraThinMaterial, in: Circle())
    }

    private var placeholderColor: Color {
        let title = book.title ?? "Untitled"
        let hash = abs(title.hashValue)
        let hue = Double(hash % 360) / 360
        return Color(hue: hue, saturation: 0.45, brightness: 0.78)
    }

    private func progressColor(for percentage: Double) -> Color {
        percentage >= 1 ? .green : .accentColor
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

        return result
    }
}
