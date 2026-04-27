import CoreGraphics
import Foundation

struct ReaderTextSelection: Identifiable, Equatable, Sendable {
    let id: UUID
    let cfiRange: String
    let text: String
    let rect: CGRect

    init(
        id: UUID = UUID(),
        cfiRange: String,
        text: String,
        rect: CGRect
    ) {
        self.id = id
        self.cfiRange = cfiRange
        self.text = text
        self.rect = rect
    }

    func moving(to rect: CGRect) -> ReaderTextSelection {
        ReaderTextSelection(id: id, cfiRange: cfiRange, text: text, rect: rect)
    }
}
