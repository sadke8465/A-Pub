import Foundation

struct HighlightSnapshot: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let cfiRange: String
    let cfiStart: String
    let spineHref: String
    let colorName: String
    let selectedText: String
    let noteText: String?

    var color: HighlightColor {
        HighlightColor(rawValue: colorName) ?? .yellow
    }

    var renderPayload: HighlightRenderPayload {
        HighlightRenderPayload(
            id: id.uuidString,
            cfiRange: cfiRange,
            colorClass: color.cssClass
        )
    }
}
