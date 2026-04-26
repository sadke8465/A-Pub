import CoreData
import Foundation

struct ReaderAppearanceOverridePayload: Codable, Sendable {
    let fontFamily: String
    let fontSize: Double
    let theme: String
    let lineSpacing: Double
    let marginStyle: String
    let textAlignment: String
    let hyphenation: Bool
}

extension Book {

    func appearanceSettings() -> ReaderAppearanceOverridePayload? {
        guard let appearanceOverride,
              let data = appearanceOverride.data(using: .utf8)
        else {
            return nil
        }

        do {
            return try JSONDecoder().decode(ReaderAppearanceOverridePayload.self, from: data)
        } catch {
            Log.shared.error("Failed to decode appearance override for book \(id?.uuidString ?? "unknown"): \(error.localizedDescription)")
            return nil
        }
    }

    func saveAppearanceOverride(_ payload: ReaderAppearanceOverridePayload) {
        do {
            let data = try JSONEncoder().encode(payload)
            appearanceOverride = String(decoding: data, as: UTF8.self)
        } catch {
            Log.shared.error("Failed to encode appearance override for book \(id?.uuidString ?? "unknown"): \(error.localizedDescription)")
        }
    }
}
