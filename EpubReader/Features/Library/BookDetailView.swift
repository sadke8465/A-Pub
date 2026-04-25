import CoreData
import SwiftUI

public struct BookDetailView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var author: String

    private let book: Book
    private let isEditMode: Bool
    private let onStartReading: (Book) -> Void

    public init(
        book: Book,
        isEditMode: Bool = false,
        onStartReading: @escaping (Book) -> Void
    ) {
        self.book = book
        self.isEditMode = isEditMode
        self.onStartReading = onStartReading
        _title = State(initialValue: book.title ?? "")
        _author = State(initialValue: book.author ?? "")
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header

                    if isEditMode {
                        editableMetadata
                    } else {
                        metadataSection
                    }

                    progressSection

                    if let description = sanitizedDescription {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                            Text(description)
                                .font(.body)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(isEditMode ? "Edit Book" : "Book Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }

                if isEditMode {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            saveChanges()
                            dismiss()
                        }
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                if !isEditMode {
                    startReadingButton
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 12)
                        .background(.ultraThinMaterial)
                }
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 16) {
            coverImage

            VStack(alignment: .leading, spacing: 8) {
                Text(book.title ?? "Untitled")
                    .font(.title)
                    .fontWeight(.bold)

                Text(book.author ?? "Unknown Author")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    formatBadge
                    if let language = sanitizedLanguage {
                        Text(language)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.secondary.opacity(0.15), in: Capsule())
                    }
                }

                if let fileSizeText {
                    Label(fileSizeText, systemImage: "doc")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if let importedAt = book.importedAt {
                    Label(importedAt.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 0)
        }
    }

    private var editableMetadata: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Metadata")
                .font(.headline)

            TextField("Title", text: $title)
                .textFieldStyle(.roundedBorder)

            TextField("Author", text: $author)
                .textFieldStyle(.roundedBorder)
        }
    }

    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Metadata")
                .font(.headline)

            metadataRow(label: "Language", value: sanitizedLanguage ?? "Unknown")
            metadataRow(label: "Format", value: "EPUB")
            metadataRow(label: "File", value: fileSizeText ?? "Unknown size")
        }
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Progress")
                .font(.headline)

            ProgressView(value: progressPercentage)
                .tint(.accentColor)

            Text("\(Int(progressPercentage * 100))% complete")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var coverImage: some View {
        Group {
            if let coverPath = book.coverImagePath,
               let image = UIImage(contentsOfFile: coverPath) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        Image(systemName: "book")
                            .font(.system(size: 28))
                            .foregroundStyle(.secondary)
                    )
            }
        }
        .frame(width: 120, height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var startReadingButton: some View {
        Button {
            onStartReading(book)
            dismiss()
        } label: {
            Text(progressPercentage > 0 ? "Continue Reading" : "Start Reading")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
    }

    private var formatBadge: some View {
        Text("EPUB")
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundStyle(.accent)
            .background(Color.accentColor.opacity(0.14), in: Capsule())
    }

    private var progressPercentage: Double {
        guard let context = book.managedObjectContext, let bookID = book.id else {
            return 0
        }

        var rawProgress: Double = 0
        context.performAndWait {
            let request = NSFetchRequest<NSManagedObject>(entityName: "ReadingProgress")
            request.predicate = NSPredicate(format: "bookID == %@", bookID as CVarArg)
            request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
            request.fetchLimit = 1

            if let progress = try? context.fetch(request).first,
               let percentage = progress.value(forKey: "percentage") as? Double {
                rawProgress = percentage
            }
        }

        return max(0, min(rawProgress, 1))
    }

    private var fileSizeText: String? {
        guard let filePath = book.filePath else {
            return nil
        }

        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: filePath)
            if let fileSize = attributes[.size] as? NSNumber {
                return ByteCountFormatter.string(fromByteCount: fileSize.int64Value, countStyle: .file)
            }
        } catch {
            Log.shared.error("Unable to determine file size: \(error.localizedDescription)")
        }

        return nil
    }

    private var sanitizedDescription: String? {
        let rawValue = (book.value(forKey: "bookDescription") as? String) ?? book.value(forKey: "description") as? String
        guard let value = rawValue?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty else {
            return nil
        }
        return value
    }

    private var sanitizedLanguage: String? {
        let value = book.language?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let value, !value.isEmpty else {
            return nil
        }
        return value.uppercased()
    }

    private func metadataRow(label: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }

    private func saveChanges() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAuthor = author.trimmingCharacters(in: .whitespacesAndNewlines)

        book.title = trimmedTitle.isEmpty ? "Untitled" : trimmedTitle
        book.author = trimmedAuthor.isEmpty ? "Unknown Author" : trimmedAuthor

        guard let context = book.managedObjectContext else {
            return
        }

        do {
            try context.save()
        } catch {
            context.rollback()
            Log.shared.error("Unable to save metadata edits: \(error.localizedDescription)")
        }
    }
}
