import Foundation
import ZIPFoundation

/// Errors surfaced by the EPUB pipeline.
public enum EPUBError: Error, Sendable {
    /// The archive could not be opened, was malformed, or the destination
    /// could not be written.
    case extractionFailed
    /// The EPUB metadata could not be parsed: a required file is missing,
    /// XML is malformed, or the OPF structure is invalid.
    case parseFailed
}

/// Expands an `.epub` archive into a unique temporary directory.
///
/// EPUB files are ZIP archives; the OPF, manifest items, and spine documents
/// must be on disk before XML parsing and `WKWebView` resource loading can
/// proceed. ``EPUBExtractor`` is an actor so concurrent imports cannot race
/// on the same temp directory.
public actor EPUBExtractor {

    public init() {}

    /// Unzips the EPUB at `url` into a fresh subdirectory of
    /// `FileManager.default.temporaryDirectory` and returns its root URL.
    ///
    /// On failure the partial directory is removed and
    /// ``EPUBError/extractionFailed`` is thrown.
    public func extract(_ url: URL) async throws -> URL {
        let fileManager = FileManager.default
        let destination = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)

        do {
            try fileManager.createDirectory(
                at: destination,
                withIntermediateDirectories: true
            )
            try fileManager.unzipItem(at: url, to: destination)
            return destination
        } catch {
            Log.shared.error(
                "EPUB extraction failed for \(url.lastPathComponent): \(error.localizedDescription)"
            )
            try? fileManager.removeItem(at: destination)
            throw EPUBError.extractionFailed
        }
    }
}
