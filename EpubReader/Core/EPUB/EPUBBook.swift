import Foundation

/// A single entry from the EPUB OPF manifest.
public struct EPUBManifestItem: Sendable, Hashable, Identifiable {

    public let id: String
    public let href: URL
    public let mediaType: String
    public let properties: [String]

    public init(
        id: String,
        href: URL,
        mediaType: String,
        properties: [String] = []
    ) {
        self.id = id
        self.href = href
        self.mediaType = mediaType
        self.properties = properties
    }
}

/// A parsed EPUB publication.
///
/// `spineItems` is the linear reading order. `manifestItems` lists every file
/// declared in the OPF manifest. `coverImagePath` is an absolute file URL into
/// the extracted EPUB directory or `nil` when no cover can be located.
public struct EPUBBook: Sendable, Hashable {

    public let title: String
    public let author: String
    public let language: String
    public let identifier: String
    public let spineItems: [EPUBChapter]
    public let manifestItems: [EPUBManifestItem]
    public let coverImagePath: URL?

    public init(
        title: String,
        author: String,
        language: String,
        identifier: String,
        spineItems: [EPUBChapter],
        manifestItems: [EPUBManifestItem],
        coverImagePath: URL?
    ) {
        self.title = title
        self.author = author
        self.language = language
        self.identifier = identifier
        self.spineItems = spineItems
        self.manifestItems = manifestItems
        self.coverImagePath = coverImagePath
    }
}
