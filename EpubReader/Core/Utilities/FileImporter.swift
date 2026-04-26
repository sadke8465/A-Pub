import CoreData
import CryptoKit
import Foundation
import ObjectiveC
import UIKit
import UniformTypeIdentifiers

public enum ImportProgress {
    case processing(filename: String)
    case done(Book)
    case skipped(filename: String)
    case failed(filename: String, Error)
}

/// Presents the iOS Files picker for `.epub` documents and returns parsed book data.
@MainActor
public struct FileImporter {

    public init() {}

    public func importEPUB() async throws -> AsyncStream<ImportProgress> {
        let pickedURLs = try await pickEPUBURLs(allowsMultipleSelection: true)
        let securityScopedURLs = pickedURLs.filter { $0.startAccessingSecurityScopedResource() }

        return AsyncStream { continuation in
            Task {
                defer {
                    securityScopedURLs.forEach { $0.stopAccessingSecurityScopedResource() }
                    continuation.finish()
                }

                let extractor = EPUBExtractor()
                let parser = EPUBParser()
                let metadataExtractor = MetadataExtractor()
                let coverExtractor = CoverImageExtractor()
                let persistenceController = PersistenceController.shared
                let backgroundContext = persistenceController.backgroundContext()

                for pickedURL in pickedURLs {
                    let filename = pickedURL.lastPathComponent
                    continuation.yield(.processing(filename: filename))

                    do {
                        let epubData = try await Self.readData(from: pickedURL)
                        let sha256 = Self.sha256Hex(for: epubData)

                        if try await Self.bookExists(with: sha256, in: backgroundContext) {
                            continuation.yield(.skipped(filename: filename))
                            continue
                        }

                        let persistedURL = try await Self.persistEPUB(
                            data: epubData,
                            suggestedFilename: filename,
                            sha256: sha256
                        )

                        let extractedRoot = try await extractor.extract(persistedURL)
                        let parsedBook = try await parser.parse(extractedRoot: extractedRoot)
                        let metadata = await metadataExtractor.extract(from: parsedBook, epubData: epubData)
                        let coverURL = try await coverExtractor.extract(
                            from: parsedBook,
                            extractedRoot: extractedRoot,
                            sha256: sha256
                        )

                        let importedBook = try await Self.insertBook(
                            in: backgroundContext,
                            metadata: metadata,
                            sourceURL: persistedURL,
                            coverURL: coverURL
                        )
                        continuation.yield(.done(importedBook))
                    } catch {
                        continuation.yield(.failed(filename: filename, error))
                    }
                }
            }
        }
    }

    public func importSingleEPUBForReader() async throws -> (EPUBBook, String, String) {
        let pickedURL = try await pickEPUBURLs(allowsMultipleSelection: false).firstUnwrapped()
        let gotSecurityScope = pickedURL.startAccessingSecurityScopedResource()
        defer {
            if gotSecurityScope {
                pickedURL.stopAccessingSecurityScopedResource()
            }
        }

        let extractor = EPUBExtractor()
        let parser = EPUBParser()
        let extractedRoot = try await extractor.extract(pickedURL)
        let book = try await parser.parse(extractedRoot: extractedRoot)
        let base64String = try await Self.encodeBase64(from: pickedURL)
        let escapedBase64String = await Self.escapeForSingleQuotedJavaScript(base64String)
        return (book, base64String, escapedBase64String)
    }

    nonisolated private static func readData(from url: URL) async throws -> Data {
        try await Task.detached(priority: .userInitiated) {
            try Data(contentsOf: url)
        }.value
    }

    nonisolated private static func encodeBase64(from url: URL) async throws -> String {
        let data = try await readData(from: url)
        return data.base64EncodedString()
    }

    nonisolated private static func escapeForSingleQuotedJavaScript(_ value: String) async -> String {
        await Task.detached(priority: .userInitiated) {
            value.replacingOccurrences(of: "'", with: "\\'")
        }.value
    }

    nonisolated private static func sha256Hex(for data: Data) -> String {
        SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
    }

    nonisolated private static func persistEPUB(data: Data, suggestedFilename: String, sha256: String) async throws -> URL {
        try await Task.detached(priority: .userInitiated) {
            let fileManager = FileManager.default
            let baseDirectory = try libraryEPUBDirectory(using: fileManager)
            let safeFilename = sanitizedFilename(suggestedFilename)
            let destinationURL = baseDirectory.appendingPathComponent("\(sha256)-\(safeFilename)")

            if fileManager.fileExists(atPath: destinationURL.path) {
                return destinationURL
            }

            try data.write(to: destinationURL, options: .atomic)
            return destinationURL
        }.value
    }

    nonisolated private static func libraryEPUBDirectory(using fileManager: FileManager) throws -> URL {
        let appSupport = try fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )

        let epubDirectory = appSupport
            .appendingPathComponent("LibraryEPUBs", isDirectory: true)

        if !fileManager.fileExists(atPath: epubDirectory.path) {
            try fileManager.createDirectory(at: epubDirectory, withIntermediateDirectories: true)
        }

        return epubDirectory
    }

    nonisolated private static func sanitizedFilename(_ filename: String) -> String {
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-_."))
        let transformedScalars = filename.unicodeScalars.map { scalar in
            allowed.contains(scalar) ? Character(scalar) : "_"
        }
        let sanitized = String(transformedScalars)
        return sanitized.isEmpty ? "book.epub" : sanitized
    }

    nonisolated private static func bookExists(with sha256: String, in context: NSManagedObjectContext) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
                    request.fetchLimit = 1
                    request.predicate = NSPredicate(format: "sha256 == %@", sha256)
                    let count = try context.count(for: request)
                    continuation.resume(returning: count > 0)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    nonisolated private static func insertBook(
        in context: NSManagedObjectContext,
        metadata: BookMetadata,
        sourceURL: URL,
        coverURL: URL?
    ) async throws -> Book {
        try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    guard let entity = NSEntityDescription.entity(forEntityName: "Book", in: context) else {
                        throw FileImporterError.bookEntityUnavailable
                    }

                    let book = Book(entity: entity, insertInto: context)
                    book.setValue(UUID(), forKey: "id")
                    book.setValue(metadata.title, forKey: "title")
                    book.setValue(metadata.author, forKey: "author")
                    book.setValue(sourceURL.path, forKey: "filePath")
                    book.setValue(coverURL?.path, forKey: "coverImagePath")
                    book.setValue(metadata.language, forKey: "language")
                    book.setValue(metadata.bookDescription, forKey: "bookDescription")
                    book.setValue(metadata.sha256, forKey: "sha256")
                    book.setValue(Date(), forKey: "importedAt")
                    book.setValue(false, forKey: "isSoftDeleted")

                    if context.hasChanges {
                        try context.save()
                    }

                    continuation.resume(returning: book)
                } catch {
                    context.rollback()
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func pickEPUBURLs(allowsMultipleSelection: Bool) async throws -> [URL] {
        try await withCheckedThrowingContinuation { continuation in
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.epub], asCopy: true)
            picker.allowsMultipleSelection = allowsMultipleSelection

            let coordinator = DocumentPickerCoordinator { result in
                continuation.resume(with: result)
            }

            picker.delegate = coordinator
            objc_setAssociatedObject(
                picker,
                &AssociatedKeys.coordinator,
                coordinator,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )

            guard let scene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }),
                  let presenter = scene.keyWindow?.rootViewController?.topMostViewController
            else {
                continuation.resume(throwing: FileImporterError.presentationUnavailable)
                return
            }

            presenter.present(picker, animated: true)
        }
    }
}

private extension UIWindowScene {
    var keyWindow: UIWindow? {
        windows.first(where: { $0.isKeyWindow })
    }
}

private extension UIViewController {
    var topMostViewController: UIViewController {
        if let presentedViewController {
            return presentedViewController.topMostViewController
        }

        if let navigationController = self as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            return visibleViewController.topMostViewController
        }

        if let tabBarController = self as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return selectedViewController.topMostViewController
        }

        return self
    }
}

private enum FileImporterError: Error {
    case presentationUnavailable
    case noSelection
    case bookEntityUnavailable
}

private enum AssociatedKeys {
    static var coordinator: UInt8 = 0
}

private final class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate {
    private let completion: (Result<[URL], Error>) -> Void

    init(completion: @escaping (Result<[URL], Error>) -> Void) {
        self.completion = completion
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard !urls.isEmpty else {
            completion(.failure(FileImporterError.noSelection))
            return
        }
        completion(.success(urls))
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        completion(.failure(CancellationError()))
    }
}

private extension Array where Element == URL {
    func firstUnwrapped() throws -> URL {
        guard let first else {
            throw FileImporterError.noSelection
        }
        return first
    }
}
