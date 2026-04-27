import Foundation

enum HighlightColor: String, CaseIterable, Codable, Identifiable, Sendable {
    case yellow
    case green
    case blue
    case pink
    case orange

    var id: String {
        rawValue
    }

    var cssClass: String {
        "hl-\(rawValue)"
    }
}
