import Foundation

struct HighlightRenderPayload: Codable, Equatable, Sendable {
    let id: String
    let cfiRange: String
    let colorClass: String
}
