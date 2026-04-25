import CryptoKit
import Foundation

public struct BookMetadata: Sendable, Hashable {
    public let title: String
    public let author: String
    public let language: String
    public let bookDescription: String
    public let identifier: String
    public let sha256: String

    public init(
        title: String,
        author: String,
        language: String,
        bookDescription: String,
        identifier: String,
        sha256: String
    ) {
        self.title = title
        self.author = author
        self.language = language
        self.bookDescription = bookDescription
        self.identifier = identifier
        self.sha256 = sha256
    }
}

public actor MetadataExtractor {

    public init() {}

    public func extract(from book: EPUBBook, epubData: Data) -> BookMetadata {
        BookMetadata(
            title: book.title,
            author: book.author,
            language: book.language,
            bookDescription: "",
            identifier: book.identifier,
            sha256: Self.sha256Hex(for: epubData)
        )
    }

    public func extract(from book: EPUBBook) -> BookMetadata {
        let fallbackData = Data(book.identifier.utf8)
        return BookMetadata(
            title: book.title,
            author: book.author,
            language: book.language,
            bookDescription: "",
            identifier: book.identifier,
            sha256: Self.sha256Hex(for: fallbackData)
        )
    }

    nonisolated private static func sha256Hex(for data: Data) -> String {
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
