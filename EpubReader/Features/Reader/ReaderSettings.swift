import Foundation
import Observation

/// Persisted reader appearance settings.
///
/// All properties are backed by `UserDefaults` via `didSet` so every
/// change survives app restarts without a separate "save" action.
/// The class is `@Observable` so SwiftUI views react to any mutation.
@Observable
@MainActor
final class ReaderAppearance {

    var fontFamily: String {
        didSet { persistToDefaultsIfNeeded(fontFamily, key: Keys.fontFamily) }
    }

    var fontSize: Double {
        didSet { persistToDefaultsIfNeeded(fontSize, key: Keys.fontSize) }
    }

    var theme: String {
        didSet { persistToDefaultsIfNeeded(theme, key: Keys.theme) }
    }

    var lineSpacing: Double {
        didSet { persistToDefaultsIfNeeded(lineSpacing, key: Keys.lineSpacing) }
    }

    var marginStyle: String {
        didSet { persistToDefaultsIfNeeded(marginStyle, key: Keys.marginStyle) }
    }

    var textAlignment: String {
        didSet { persistToDefaultsIfNeeded(textAlignment, key: Keys.textAlignment) }
    }

    var hyphenation: Bool {
        didSet { persistToDefaultsIfNeeded(hyphenation, key: Keys.hyphenation) }
    }

    private let persistToDefaults: Bool

    init(persistToDefaults: Bool = true) {
        self.persistToDefaults = persistToDefaults
        let ud = UserDefaults.standard
        fontFamily    = ud.string(forKey: Keys.fontFamily) ?? "Literata"
        let storedSize = ud.double(forKey: Keys.fontSize)
        fontSize      = storedSize > 0 ? storedSize : 18
        theme         = ud.string(forKey: Keys.theme) ?? "light"
        let storedSpacing = ud.double(forKey: Keys.lineSpacing)
        lineSpacing   = storedSpacing > 0 ? storedSpacing : 1.5
        marginStyle   = ud.string(forKey: Keys.marginStyle) ?? "normal"
        textAlignment = ud.string(forKey: Keys.textAlignment) ?? "justify"
        hyphenation   = ud.object(forKey: Keys.hyphenation) as? Bool ?? true
    }

    /// CSS custom-property values for each setting, ready for injection into the rendition theme.
    var cssVariables: [String: String] {
        [
            "--reader-font-family": fontFamily,
            "--reader-font-size":   "\(Int(fontSize))px",
            "--reader-line-height": "\(lineSpacing)",
            "--reader-margin":      marginPixels,
            "--reader-text-align":  textAlignment == "justify" ? "justify" : "left",
            "--reader-hyphens":     hyphenation ? "auto" : "manual",
        ]
    }

    /// Push every current setting to the JS rendition via the bridge.
    /// The JS functions (setTheme, setFontFamily, etc.) are wired in tasks 2b.3–2b.4.
    func applyAll(via bridge: EPUBBridge) {
        bridge.callJS("setTheme('\(theme)')")
        bridge.callJS("setFontFamily('\(fontFamily)')")
        bridge.callJS("setFontSize(\(Int(fontSize)))")
        bridge.callJS("setLineSpacing(\(lineSpacing))")
        bridge.callJS("setMargin(\(marginInt))")
        bridge.callJS("setJustify(\(textAlignment == "justify"))")
        bridge.callJS("setHyphenation(\(hyphenation))")
    }


    private func persistToDefaultsIfNeeded(_ value: Any, key: String) {
        guard persistToDefaults else { return }
        UserDefaults.standard.set(value, forKey: key)
    }

    private var marginPixels: String { "\(marginInt)px" }

    private var marginInt: Int {
        switch marginStyle {
        case "narrow": return 8
        case "wide":   return 40
        default:       return 24
        }
    }

    private enum Keys {
        static let fontFamily    = "appearance.fontFamily"
        static let fontSize      = "appearance.fontSize"
        static let theme         = "appearance.theme"
        static let lineSpacing   = "appearance.lineSpacing"
        static let marginStyle   = "appearance.marginStyle"
        static let textAlignment = "appearance.textAlignment"
        static let hyphenation   = "appearance.hyphenation"
    }
}
