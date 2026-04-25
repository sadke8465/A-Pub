import Foundation

/// A single navigable unit inside an EPUB.
///
/// Spine entries and table-of-contents nodes share this type. Spine items are
/// flat (`subChapters` empty) while TOC nodes may nest. The `label` is sourced
/// from the navigation document (or NCX) when available; for spine items
/// without a TOC match it falls back to the file name of `href`.
public struct EPUBChapter: Sendable, Hashable, Identifiable {

    public let id: String
    public let href: URL
    public let mediaType: String
    public let label: String
    public let subChapters: [EPUBChapter]

    public init(
        id: String,
        href: URL,
        mediaType: String,
        label: String,
        subChapters: [EPUBChapter] = []
    ) {
        self.id = id
        self.href = href
        self.mediaType = mediaType
        self.label = label
        self.subChapters = subChapters
    }
}
