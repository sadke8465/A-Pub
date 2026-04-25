import Foundation

/// Parses an extracted EPUB directory into an ``EPUBBook``.
///
/// The parser walks `META-INF/container.xml` to locate the OPF, extracts
/// metadata, manifest, and spine, then builds a navigation tree. EPUB3 nav
/// documents are preferred; a missing or malformed nav falls back to NCX.
/// All XML is parsed with `XMLParser` (no third-party dependency).
public actor EPUBParser {

    public init() {}

    /// Parses the EPUB rooted at `extractedRoot` (the directory produced by
    /// ``EPUBExtractor/extract(_:)``).
    ///
    /// - Throws: ``EPUBError/parseFailed`` if any required element is missing
    ///   or malformed.
    public func parse(extractedRoot: URL) async throws -> EPUBBook {
        let opfURL = try findOPFURL(extractedRoot: extractedRoot)
        let opfDir = opfURL.deletingLastPathComponent()

        guard let packageNode = parseXMLTree(at: opfURL) else {
            Log.shared.error("EPUB parse failed: OPF unreadable at \(opfURL.path)")
            throw EPUBError.parseFailed
        }

        let metadataNode = packageNode.firstChild(named: "metadata")
        let manifestNode = packageNode.firstChild(named: "manifest")
        let spineNode = packageNode.firstChild(named: "spine")

        guard let metadataNode, let manifestNode, let spineNode else {
            Log.shared.error("EPUB parse failed: OPF missing metadata/manifest/spine")
            throw EPUBError.parseFailed
        }

        let metadata = parseMetadata(metadataNode)
        let manifestItems = parseManifest(manifestNode, opfDir: opfDir)
        let manifestByID = Dictionary(manifestItems.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })

        let spineIDs = parseSpine(spineNode)
        let ncxID = spineNode.attributes["toc"]

        let tocByHref = buildTOCByHref(
            manifestItems: manifestItems,
            manifestByID: manifestByID,
            ncxID: ncxID
        )

        var spineItems: [EPUBChapter] = []
        spineItems.reserveCapacity(spineIDs.count)
        for id in spineIDs {
            guard let item = manifestByID[id] else { continue }
            let key = canonicalKey(for: item.href)
            let entry = tocByHref[key]
            spineItems.append(
                EPUBChapter(
                    id: item.id,
                    href: item.href,
                    mediaType: item.mediaType,
                    label: entry?.label ?? item.href.deletingPathExtension().lastPathComponent,
                    subChapters: entry?.subChapters ?? []
                )
            )
        }

        let coverImagePath = resolveCover(
            metadata: metadataNode,
            manifestItems: manifestItems,
            manifestByID: manifestByID
        )

        return EPUBBook(
            title: metadata.title,
            author: metadata.author,
            language: metadata.language,
            identifier: metadata.identifier,
            description: metadata.description,
            spineItems: spineItems,
            manifestItems: manifestItems,
            coverImagePath: coverImagePath
        )
    }

    // MARK: - container.xml

    private func findOPFURL(extractedRoot: URL) throws -> URL {
        let containerURL = extractedRoot
            .appendingPathComponent("META-INF", isDirectory: true)
            .appendingPathComponent("container.xml")

        guard let containerRoot = parseXMLTree(at: containerURL) else {
            Log.shared.error("EPUB parse failed: container.xml missing or invalid")
            throw EPUBError.parseFailed
        }

        let rootfile = containerRoot
            .firstChild(named: "rootfiles")?
            .firstChild(named: "rootfile")

        guard let fullPath = rootfile?.attributes["full-path"], !fullPath.isEmpty else {
            Log.shared.error("EPUB parse failed: container.xml has no rootfile")
            throw EPUBError.parseFailed
        }

        return resolveRelativePath(fullPath, from: extractedRoot)
    }

    // MARK: - metadata

    private struct ParsedMetadata {
        var title: String
        var author: String
        var language: String
        var identifier: String
        var description: String
    }

    private func parseMetadata(_ node: XMLNode) -> ParsedMetadata {
        var titles: [String] = []
        var authors: [String] = []
        var languages: [String] = []
        var identifiers: [String] = []
        var descriptions: [String] = []

        for child in node.children {
            let name = child.name
            let text = child.collectedText.trimmedWhitespace
            switch name {
            case "title": if !text.isEmpty { titles.append(text) }
            case "creator": if !text.isEmpty { authors.append(text) }
            case "language": if !text.isEmpty { languages.append(text) }
            case "identifier": if !text.isEmpty { identifiers.append(text) }
            case "description": if !text.isEmpty { descriptions.append(text) }
            default: break
            }
        }

        return ParsedMetadata(
            title: titles.first ?? "",
            author: authors.joined(separator: ", "),
            language: languages.first ?? "",
            identifier: identifiers.first ?? "",
            description: descriptions.first ?? ""
        )
    }

    // MARK: - manifest

    private func parseManifest(_ node: XMLNode, opfDir: URL) -> [EPUBManifestItem] {
        var items: [EPUBManifestItem] = []
        items.reserveCapacity(node.children.count)
        for child in node.children where child.name == "item" {
            guard
                let id = child.attributes["id"],
                let href = child.attributes["href"]
            else { continue }
            let mediaType = child.attributes["media-type"] ?? ""
            let properties = (child.attributes["properties"] ?? "")
                .split(whereSeparator: { $0.isWhitespace })
                .map(String.init)
            let absolute = resolveRelativePath(href, from: opfDir)
            items.append(
                EPUBManifestItem(
                    id: id,
                    href: absolute,
                    mediaType: mediaType,
                    properties: properties
                )
            )
        }
        return items
    }

    // MARK: - spine

    private func parseSpine(_ node: XMLNode) -> [String] {
        node.children.compactMap { child in
            guard child.name == "itemref" else { return nil }
            return child.attributes["idref"]
        }
    }

    // MARK: - TOC

    private struct TOCEntry {
        let label: String
        let subChapters: [EPUBChapter]
    }

    private func buildTOCByHref(
        manifestItems: [EPUBManifestItem],
        manifestByID: [String: EPUBManifestItem],
        ncxID: String?
    ) -> [String: TOCEntry] {
        if let nav = manifestItems.first(where: { $0.properties.contains("nav") }),
           let entries = parseNavDocument(at: nav.href) {
            return flattenTOC(entries)
        }

        if let ncxID, let ncx = manifestByID[ncxID],
           let entries = parseNCXDocument(at: ncx.href) {
            return flattenTOC(entries)
        }

        if let ncx = manifestItems.first(where: { $0.mediaType == "application/x-dtbncx+xml" }),
           let entries = parseNCXDocument(at: ncx.href) {
            return flattenTOC(entries)
        }

        return [:]
    }

    private func flattenTOC(_ chapters: [EPUBChapter]) -> [String: TOCEntry] {
        var result: [String: TOCEntry] = [:]
        for chapter in chapters {
            let key = canonicalKey(for: chapter.href)
            if result[key] == nil {
                result[key] = TOCEntry(
                    label: chapter.label,
                    subChapters: chapter.subChapters
                )
            }
            for nested in flattenTOC(chapter.subChapters) where result[nested.key] == nil {
                result[nested.key] = nested.value
            }
        }
        return result
    }

    private func parseNavDocument(at url: URL) -> [EPUBChapter]? {
        guard let root = parseXMLTree(at: url) else { return nil }
        guard let nav = findTOCNav(in: root) else { return nil }
        let baseDir = url.deletingLastPathComponent()
        guard let ol = nav.firstDescendant(named: "ol") else { return nil }
        return parseNavList(ol, baseDir: baseDir)
    }

    private func findTOCNav(in node: XMLNode) -> XMLNode? {
        if node.name == "nav",
           let type = node.attributes["epub:type"], type.contains("toc") {
            return node
        }
        for child in node.children {
            if let found = findTOCNav(in: child) { return found }
        }
        return nil
    }

    private func parseNavList(_ ol: XMLNode, baseDir: URL) -> [EPUBChapter] {
        var chapters: [EPUBChapter] = []
        for li in ol.children where li.name == "li" {
            guard let anchor = li.firstDescendant(named: "a") else { continue }
            guard let href = anchor.attributes["href"] else { continue }
            let label = anchor.collectedText.trimmedWhitespace
            let nestedOL = li.children.first(where: { $0.name == "ol" })
            let subChapters = nestedOL.map { parseNavList($0, baseDir: baseDir) } ?? []
            chapters.append(
                EPUBChapter(
                    id: anchor.attributes["id"] ?? UUID().uuidString,
                    href: resolveRelativePath(href, from: baseDir),
                    mediaType: "application/xhtml+xml",
                    label: label,
                    subChapters: subChapters
                )
            )
        }
        return chapters
    }

    private func parseNCXDocument(at url: URL) -> [EPUBChapter]? {
        guard let root = parseXMLTree(at: url) else { return nil }
        guard let navMap = root.firstDescendant(named: "navMap") else { return nil }
        let baseDir = url.deletingLastPathComponent()
        return navMap.children
            .filter { $0.name == "navPoint" }
            .map { parseNavPoint($0, baseDir: baseDir) }
    }

    private func parseNavPoint(_ node: XMLNode, baseDir: URL) -> EPUBChapter {
        let label = node
            .firstChild(named: "navLabel")?
            .firstChild(named: "text")?
            .collectedText
            .trimmedWhitespace ?? ""
        let src = node.firstChild(named: "content")?.attributes["src"] ?? ""
        let href = resolveRelativePath(src, from: baseDir)
        let subPoints = node.children
            .filter { $0.name == "navPoint" }
            .map { parseNavPoint($0, baseDir: baseDir) }
        return EPUBChapter(
            id: node.attributes["id"] ?? UUID().uuidString,
            href: href,
            mediaType: "application/xhtml+xml",
            label: label,
            subChapters: subPoints
        )
    }

    // MARK: - cover

    private func resolveCover(
        metadata: XMLNode,
        manifestItems: [EPUBManifestItem],
        manifestByID: [String: EPUBManifestItem]
    ) -> URL? {
        if let cover = manifestItems.first(where: { $0.properties.contains("cover-image") }) {
            return cover.href
        }

        for child in metadata.children where child.name == "meta" {
            if child.attributes["name"] == "cover",
               let id = child.attributes["content"],
               let item = manifestByID[id] {
                return item.href
            }
        }

        return nil
    }

    // MARK: - helpers

    private func parseXMLTree(at url: URL) -> XMLNode? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        let parser = XMLParser(data: data)
        let builder = XMLTreeBuilder()
        parser.delegate = builder
        parser.shouldProcessNamespaces = true
        guard parser.parse() else { return nil }
        return builder.root
    }

    private func resolveRelativePath(_ path: String, from base: URL) -> URL {
        let parts = path.split(separator: "#", maxSplits: 1)
        let pathPart = parts.first.map(String.init) ?? path
        let fragment = parts.count > 1 ? String(parts[1]) : nil

        let decoded = pathPart.removingPercentEncoding ?? pathPart
        let fileURL = URL(fileURLWithPath: decoded, relativeTo: base).standardizedFileURL

        if let fragment,
           var components = URLComponents(url: fileURL, resolvingAgainstBaseURL: true) {
            components.fragment = fragment
            return components.url ?? fileURL
        }

        return fileURL
    }

    private func canonicalKey(for url: URL) -> String {
        url.standardizedFileURL.path
    }
}

// MARK: - XML tree builder

/// Minimal in-memory tree built from `XMLParser` events. The parser keeps
/// qualified names (e.g. `dc:title`) so namespace prefixes survive.
private final class XMLNode {
    enum Content {
        case text(String)
        case child(XMLNode)
    }

    let name: String
    var attributes: [String: String]
    private var contents: [Content] = []
    weak var parent: XMLNode?

    init(name: String, attributes: [String: String] = [:]) {
        self.name = name
        self.attributes = attributes
    }

    var children: [XMLNode] {
        contents.compactMap {
            if case let .child(child) = $0 {
                return child
            }
            return nil
        }
    }

    var collectedText: String {
        var collected = ""
        for content in contents {
            switch content {
            case let .text(value):
                collected += value
            case let .child(child):
                collected += child.collectedText
            }
        }
        return collected
    }

    func append(text: String) {
        guard !text.isEmpty else { return }
        if case let .text(existing)? = contents.last {
            contents[contents.count - 1] = .text(existing + text)
        } else {
            contents.append(.text(text))
        }
    }

    func append(child: XMLNode) {
        contents.append(.child(child))
    }

    func firstChild(named name: String) -> XMLNode? {
        children.first { $0.name == name }
    }

    func firstDescendant(named name: String) -> XMLNode? {
        for child in children {
            if child.name == name { return child }
            if let found = child.firstDescendant(named: name) { return found }
        }
        return nil
    }
}

private final class XMLTreeBuilder: NSObject, XMLParserDelegate {

    var root: XMLNode?
    private var current: XMLNode?

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String: String] = [:]
    ) {
        let node = XMLNode(name: elementName, attributes: attributeDict)
        node.parent = current
        if let current {
            current.append(child: node)
        } else {
            root = node
        }
        current = node
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        current?.append(text: string)
    }

    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        if let s = String(data: CDATABlock, encoding: .utf8) {
            current?.append(text: s)
        }
    }

    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        current = current?.parent
    }
}

private extension String {
    var trimmedWhitespace: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
