import SwiftUI

struct AppearanceSettings: View {

    @Bindable var appearance: ReaderAppearance
    let applyFontSize: (Int) -> Void
    let applyFontFamily: (String) -> Void
    let applyTheme: (String) -> Void
    let applyMargin: (Int) -> Void
    let applyLineSpacing: (Double) -> Void
    let applyJustify: (Bool) -> Void
    let applyHyphenation: (Bool) -> Void
    var onAppearanceChanged: (() -> Void)? = nil
    var onSaveAsDefaultForBook: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss

    private struct FontOption {
        let family: String
        let displayName: String
    }

    private struct ThemeOption {
        let name: String
        let background: Color
        let foreground: Color
        let label: String
    }

    private let fontOptions: [FontOption] = [
        FontOption(family: "Literata", displayName: "Literata"),
        FontOption(family: "EBGaramond", displayName: "EB Garamond"),
        FontOption(family: "iAWriterQuattroS", displayName: "iA Quattro"),
        FontOption(family: "Charter", displayName: "Charter"),
        FontOption(family: "Georgia", displayName: "Georgia"),
    ]

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
            Form {
                themeSection
                fontSizeSection
                fontFamilySection
                marginSection
                lineSpacingSection
                textSection
            }
            .navigationTitle("Appearance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save for Book") {
                        onSaveAsDefaultForBook?()
                    }
                    .disabled(onSaveAsDefaultForBook == nil)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private var themeSection: some View {
        Section("Theme") {
            HStack(spacing: AppSpacing.md) {
                ForEach(themeOptions, id: \.name) { option in
                    themeButton(for: option)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, AppSpacing.xs)
        }
    }

    private var fontSizeSection: some View {
        Section("Font Size") {
            LabeledContent("Size") {
                Text("\(Int(appearance.fontSize)) pt")
                    .monospacedDigit()
            }

            Stepper("Font size", value: $appearance.fontSize, in: 12...32, step: 1)
                .onChange(of: appearance.fontSize) { _, newValue in
                    applyFontSize(Int(newValue))
                    onAppearanceChanged?()
                }
        }
    }

    private var fontFamilySection: some View {
        Section("Font") {
            Picker("Family", selection: $appearance.fontFamily) {
                ForEach(fontOptions, id: \.family) { option in
                    Text(option.displayName).tag(option.family)
                }
            }
            .onChange(of: appearance.fontFamily) { _, newValue in
                applyFontFamily(newValue)
                onAppearanceChanged?()
            }
        }
    }

    private var marginSection: some View {
        Section("Margins") {
            Picker("Margins", selection: $appearance.marginStyle) {
                Text("Narrow").tag("narrow")
                Text("Normal").tag("normal")
                Text("Wide").tag("wide")
            }
            .pickerStyle(.segmented)
            .onChange(of: appearance.marginStyle) { _, newValue in
                applyMargin(marginPixels(for: newValue))
                onAppearanceChanged?()
            }
        }
    }

    private var lineSpacingSection: some View {
        Section("Line Spacing") {
            LabeledContent("Spacing") {
                Text(String(format: "%.1f", appearance.lineSpacing))
                    .monospacedDigit()
            }

            Slider(value: $appearance.lineSpacing, in: 1.2...2.0, step: 0.1)
                .onChange(of: appearance.lineSpacing) { _, newValue in
                    applyLineSpacing(newValue)
                    onAppearanceChanged?()
                }
        }
    }

    private var textSection: some View {
        Section("Text") {
            Toggle("Justify Text", isOn: justifyBinding)

            Toggle("Hyphenation", isOn: $appearance.hyphenation)
                .onChange(of: appearance.hyphenation) { _, newValue in
                    applyHyphenation(newValue)
                    onAppearanceChanged?()
                }
        }
    }

    private func themeButton(for option: ThemeOption) -> some View {
        let isSelected = appearance.theme == option.name

        return Button {
            appearance.theme = option.name
            applyTheme(option.name)
            onAppearanceChanged?()
        } label: {
            VStack(spacing: AppSpacing.xs) {
                Circle()
                    .fill(option.background)
                    .frame(width: AppSize.minTapTarget, height: AppSize.minTapTarget)
                    .overlay {
                        Text("A")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(option.foreground)
                    }
                    .overlay {
                        Circle()
                            .strokeBorder(
                                isSelected ? Color.accentColor : Color(.separator),
                                lineWidth: isSelected ? 2.5 : 0.75
                            )
                    }

                Text(option.label)
                    .font(.footnote)
                    .foregroundStyle(isSelected ? Color.accentColor : .secondary)
            }
            .frame(minWidth: AppSize.minTapTarget)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(option.label) theme\(isSelected ? ", selected" : "")")
    }

    private var justifyBinding: Binding<Bool> {
        Binding(
            get: { appearance.textAlignment == "justify" },
            set: { newValue in
                appearance.textAlignment = newValue ? "justify" : "left"
                applyJustify(newValue)
                onAppearanceChanged?()
            }
        )
    }

    private func marginPixels(for style: String) -> Int {
        switch style {
        case "narrow": return 8
        case "wide": return 40
        default: return 24
        }
    }
}

#Preview {
    Text("Reader behind the sheet")
        .sheet(isPresented: .constant(true)) {
            AppearanceSettings(
                appearance: ReaderAppearance(),
                applyFontSize: { _ in },
                applyFontFamily: { _ in },
                applyTheme: { _ in },
                applyMargin: { _ in },
                applyLineSpacing: { _ in },
                applyJustify: { _ in },
                applyHyphenation: { _ in }
            )
        }
}
