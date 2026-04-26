import SwiftUI

struct AppearanceSettings: View {

    @Bindable var appearance: ReaderAppearance
    let bridge: EPUBBridge

    private struct FontOption {
        let family: String
        let displayName: String
        let uiFontName: String
    }

    private let fontOptions: [FontOption] = [
        FontOption(family: "Literata",         displayName: "Literata",    uiFontName: "Literata-Regular"),
        FontOption(family: "EBGaramond",       displayName: "EB Garamond", uiFontName: "EBGaramond-Regular"),
        FontOption(family: "iAWriterQuattroS", displayName: "iA Quattro",  uiFontName: "iAWriterQuattroS-Regular"),
        FontOption(family: "Charter",          displayName: "Charter",     uiFontName: "Charter"),
        FontOption(family: "Georgia",          displayName: "Georgia",     uiFontName: "Georgia"),
    ]

    private struct ThemeOption {
        let name: String
        let background: Color
        let foreground: Color
        let label: String
    }

    private let themeOptions: [ThemeOption] = [
        ThemeOption(
            name: "light",
            background: Color(red: 1, green: 1, blue: 0.97),
            foreground: Color(red: 0.11, green: 0.11, blue: 0.12),
            label: "Light"
        ),
        ThemeOption(
            name: "dark",
            background: Color(red: 0.11, green: 0.11, blue: 0.12),
            foreground: Color(red: 0.9, green: 0.9, blue: 0.92),
            label: "Dark"
        ),
        ThemeOption(
            name: "sepia",
            background: Color(red: 0.957, green: 0.925, blue: 0.847),
            foreground: Color(red: 0.23, green: 0.18, blue: 0.18),
            label: "Sepia"
        ),
        ThemeOption(
            name: "custom",
            background: Color(.systemGray3),
            foreground: Color.primary,
            label: "Custom"
        ),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    fontSizeSection
                    Divider()
                    fontFamilySection
                    Divider()
                    themeSection
                    Divider()
                    marginSection
                    Divider()
                    lineSpacingSection
                    Divider()
                    togglesSection
                }
                .padding()
            }
            .navigationTitle("Appearance")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium, .large])
    }

    // MARK: - Font Size

    private var fontSizeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("Font Size")
            HStack {
                Text("\(Int(appearance.fontSize)) pt")
                    .font(.body.monospacedDigit())
                    .frame(minWidth: 52, alignment: .leading)
                Stepper("Font size", value: $appearance.fontSize, in: 12...32, step: 1)
                    .labelsHidden()
                    .onChange(of: appearance.fontSize) { _, newValue in
                        bridge.applyFontSize(Int(newValue))
                    }
            }
        }
    }

    // MARK: - Font Family

    private var fontFamilySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("Font")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(fontOptions, id: \.family) { option in
                        fontButton(for: option)
                    }
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 4)
            }
        }
    }

    private func fontButton(for option: FontOption) -> some View {
        let isSelected = appearance.fontFamily == option.family
        return Button {
            appearance.fontFamily = option.family
            bridge.applyFontFamily(option.family)
        } label: {
            VStack(spacing: 4) {
                Text("Aa")
                    .font(.custom(option.uiFontName, size: 20))
                    .foregroundStyle(.primary)
                Text(option.displayName)
                    .font(.caption2)
                    .foregroundStyle(isSelected ? Color.accentColor : .secondary)
            }
            .frame(width: 80, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(
                                isSelected ? Color.accentColor : Color(.separator),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(option.displayName) font\(isSelected ? ", selected" : "")")
    }

    // MARK: - Theme

    private var themeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("Theme")
            HStack(spacing: 20) {
                ForEach(themeOptions, id: \.name) { option in
                    themeButton(for: option)
                }
            }
        }
    }

    private func themeButton(for option: ThemeOption) -> some View {
        let isSelected = appearance.theme == option.name
        return Button {
            appearance.theme = option.name
            bridge.applyTheme(option.name)
        } label: {
            VStack(spacing: 6) {
                Circle()
                    .fill(option.background)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Text("A")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(option.foreground)
                    )
                    .overlay(
                        Circle()
                            .strokeBorder(
                                isSelected ? Color.accentColor : Color(.separator),
                                lineWidth: isSelected ? 2.5 : 0.75
                            )
                    )
                Text(option.label)
                    .font(.caption2)
                    .foregroundStyle(isSelected ? Color.accentColor : .secondary)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(option.label) theme\(isSelected ? ", selected" : "")")
    }

    // MARK: - Margins

    private var marginSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("Margins")
            Picker("Margins", selection: $appearance.marginStyle) {
                Text("Narrow").tag("narrow")
                Text("Normal").tag("normal")
                Text("Wide").tag("wide")
            }
            .pickerStyle(.segmented)
            .onChange(of: appearance.marginStyle) { _, newValue in
                bridge.applyMargin(marginPixels(for: newValue))
            }
        }
    }

    // MARK: - Line Spacing

    private var lineSpacingSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                sectionHeader("Line Spacing")
                Spacer()
                Text(String(format: "%.1f×", appearance.lineSpacing))
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            Slider(value: $appearance.lineSpacing, in: 1.2...2.0, step: 0.1)
                .onChange(of: appearance.lineSpacing) { _, newValue in
                    bridge.applyLineSpacing(newValue)
                }
        }
    }

    // MARK: - Toggles

    private var togglesSection: some View {
        VStack(spacing: 0) {
            Toggle("Justify Text", isOn: justifyBinding)
                .padding(.vertical, 8)
            Divider()
            Toggle("Hyphenation", isOn: $appearance.hyphenation)
                .onChange(of: appearance.hyphenation) { _, newValue in
                    bridge.applyHyphenation(newValue)
                }
                .padding(.vertical, 8)
        }
    }

    // MARK: - Helpers

    private var justifyBinding: Binding<Bool> {
        Binding(
            get: { appearance.textAlignment == "justify" },
            set: { newValue in
                appearance.textAlignment = newValue ? "justify" : "left"
                bridge.applyJustify(newValue)
            }
        )
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.caption)
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
            .tracking(0.5)
    }

    private func marginPixels(for style: String) -> Int {
        switch style {
        case "narrow": return 8
        case "wide":   return 40
        default:       return 24
        }
    }
}

#Preview {
    Text("Reader behind the sheet")
        .sheet(isPresented: .constant(true)) {
            AppearanceSettings(
                appearance: ReaderAppearance(),
                bridge: EPUBBridge()
            )
        }
}
