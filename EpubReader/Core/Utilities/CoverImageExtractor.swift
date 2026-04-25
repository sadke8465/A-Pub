import Foundation
import UIKit

public enum CoverImageExtractorError: Error {
    case cannotCreateApplicationSupportDirectory
    case cannotEncodeJPEG
    case cannotWriteCover
}

public actor CoverImageExtractor {

    public init() {}

    public func extract(from book: EPUBBook, extractedRoot: URL, sha256: String) async throws -> URL? {
        guard let sourceURL = try await locateCoverURL(from: book, extractedRoot: extractedRoot) else {
            Log.shared.info("Cover extraction: no candidate found for \(book.title)")
            return nil
        }

        let data = try Data(contentsOf: sourceURL)
        guard let image = UIImage(data: data) else {
            Log.shared.error("Cover extraction: unsupported image data at \(sourceURL.path)")
            return nil
        }

        let resizedImage = resized(image, maxSize: CGSize(width: 400, height: 600))
        guard let jpegData = resizedImage.jpegData(compressionQuality: 0.85) else {
            throw CoverImageExtractorError.cannotEncodeJPEG
        }

        let destinationURL = try destinationURL(forSHA256: sha256)
        do {
            try jpegData.write(to: destinationURL, options: .atomic)
            return destinationURL
        } catch {
            Log.shared.error("Cover extraction: failed writing JPEG at \(destinationURL.path): \(error.localizedDescription)")
            throw CoverImageExtractorError.cannotWriteCover
        }
    }

    private func locateCoverURL(from book: EPUBBook, extractedRoot: URL) async throws -> URL? {
        if let manifestCover = book.manifestItems.first(where: { $0.properties.contains("cover-image") }) {
            return manifestCover.href
        }

        if let resolvedCover = book.coverImagePath {
            return resolvedCover
        }

        guard let firstSpineItem = book.spineItems.first else {
            return nil
        }

        return try await firstImageURL(in: firstSpineItem.href, extractedRoot: extractedRoot)
    }

    private func firstImageURL(in htmlURL: URL, extractedRoot: URL) async throws -> URL? {
        let normalizedHTMLURL = htmlURL.removingFragment
        let htmlData = try Data(contentsOf: normalizedHTMLURL)
        guard let html = String(data: htmlData, encoding: .utf8) ?? String(data: htmlData, encoding: .isoLatin1) else {
            return nil
        }

        let pattern = "<img[^>]*\\bsrc\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>"
        let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        let searchRange = NSRange(html.startIndex..<html.endIndex, in: html)
        guard let match = regex.firstMatch(in: html, options: [], range: searchRange),
              let srcRange = Range(match.range(at: 1), in: html) else {
            return nil
        }

        let src = String(html[srcRange]).trimmingCharacters(in: .whitespacesAndNewlines)
        guard !src.isEmpty else {
            return nil
        }

        if src.hasPrefix("data:") {
            Log.shared.info("Cover extraction: first spine image is data URI and cannot be persisted directly")
            return nil
        }

        if let absoluteURL = URL(string: src), absoluteURL.scheme != nil {
            return absoluteURL
        }

        return resolveRelativePath(src, from: normalizedHTMLURL.deletingLastPathComponent(), extractedRoot: extractedRoot)
    }

    private func resolveRelativePath(_ path: String, from baseDir: URL, extractedRoot: URL) -> URL {
        let sanitized = path.replacingOccurrences(of: "\\", with: "/")
        if sanitized.hasPrefix("/") {
            let relativePath = String(sanitized.dropFirst())
            return extractedRoot.appendingPathComponent(relativePath)
        }
        return URL(fileURLWithPath: sanitized, relativeTo: baseDir).standardizedFileURL
    }

    private func resized(_ image: UIImage, maxSize: CGSize) -> UIImage {
        let widthRatio = maxSize.width / image.size.width
        let heightRatio = maxSize.height / image.size.height
        let scale = min(widthRatio, heightRatio, 1)
        let targetSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    private func destinationURL(forSHA256 sha256: String) throws -> URL {
        guard let applicationSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            throw CoverImageExtractorError.cannotCreateApplicationSupportDirectory
        }

        let coversDirectory = applicationSupport.appendingPathComponent("covers", isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: coversDirectory, withIntermediateDirectories: true)
        } catch {
            Log.shared.error("Cover extraction: failed creating covers directory: \(error.localizedDescription)")
            throw CoverImageExtractorError.cannotCreateApplicationSupportDirectory
        }

        return coversDirectory.appendingPathComponent("\(sha256).jpg")
    }
}

private extension URL {
    var removingFragment: URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }
        components.fragment = nil
        return components.url ?? self
    }
}
