import CoreData
import Foundation

private struct ReaderAppearanceOverridePayload: Codable {
    let fontFamily: String
    let fontSize: Double
    let theme: String
    let lineSpacing: Double
    let marginStyle: String
    let textAlignment: String
    let hyphenation: Bool
}

extension Book {

    var appearanceOverride: String? {
        get { primitiveValue(forKey: "appearanceOverride") as? String }
        set { setPrimitiveValue(newValue, forKey: "appearanceOverride") }
    }

    var locationsCache: String? {
        get { primitiveValue(forKey: "locationsCache") as? String }
        set { setPrimitiveValue(newValue, forKey: "locationsCache") }
    }

    func appearanceSettings() -> ReaderAppearance? {
        guard let appearanceOverride,
              let data = appearanceOverride.data(using: .utf8)
        else {
            return nil
        }

        do {
            let payload = try JSONDecoder().decode(ReaderAppearanceOverridePayload.self, from: data)
            return ReaderAppearance(payload: payload)
        } catch {
            Log.shared.error("Failed to decode appearance override for book \(id?.uuidString ?? "unknown"): \(error.localizedDescription)")
            return nil
        }
    }

    func saveAppearanceOverride(_ appearance: ReaderAppearance) {
        let payload = ReaderAppearanceOverridePayload(
            fontFamily: appearance.fontFamily,
            fontSize: appearance.fontSize,
            theme: appearance.theme,
            lineSpacing: appearance.lineSpacing,
            marginStyle: appearance.marginStyle,
            textAlignment: appearance.textAlignment,
            hyphenation: appearance.hyphenation
        )

        do {
            let data = try JSONEncoder().encode(payload)
            appearanceOverride = String(decoding: data, as: UTF8.self)
        } catch {
            Log.shared.error("Failed to encode appearance override for book \(id?.uuidString ?? "unknown"): \(error.localizedDescription)")
        }
    }
}

extension ReaderAppearance {
    fileprivate convenience init(payload: ReaderAppearanceOverridePayload) {
        self.init(persistToDefaults: false)
        fontFamily = payload.fontFamily
        fontSize = payload.fontSize
        theme = payload.theme
        lineSpacing = payload.lineSpacing
        marginStyle = payload.marginStyle
        textAlignment = payload.textAlignment
        hyphenation = payload.hyphenation
    }
}
