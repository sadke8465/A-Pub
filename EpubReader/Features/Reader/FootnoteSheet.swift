import SwiftUI

struct FootnotePayload: Identifiable {
    let id = UUID()
    let href: String
    let text: String
}

struct FootnoteSheet: View {

    let footnote: FootnotePayload

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    if !footnote.href.isEmpty {
                        Text(footnote.href)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    Text(footnote.text.isEmpty ? "No footnote content available." : footnote.text)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            }
            .navigationTitle("Footnote")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.fraction(0.25), .medium])
    }
}
