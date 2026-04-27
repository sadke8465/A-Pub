import SwiftUI

struct ReaderTOCPanel: View {

    let chapters: [EPUBChapter]
    let currentSpineHref: String
    let onSelectChapter: (EPUBChapter) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(chapters) { chapter in
                    ReaderTOCRow(
                        chapter: chapter,
                        currentSpineHref: currentSpineHref,
                        onSelectChapter: selectChapter
                    )
                }
            }
            .navigationTitle("Contents")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func selectChapter(_ chapter: EPUBChapter) {
        onSelectChapter(chapter)
        dismiss()
    }
}

private struct ReaderTOCRow: View {

    let chapter: EPUBChapter
    let currentSpineHref: String
    let onSelectChapter: (EPUBChapter) -> Void

    var body: some View {
        if chapter.subChapters.isEmpty {
            Button {
                onSelectChapter(chapter)
            } label: {
                chapterLabel
            }
            .buttonStyle(.plain)
            .listRowBackground(isCurrentChapter ? Color.accentColor.opacity(0.16) : Color.clear)
        } else {
            DisclosureGroup {
                ForEach(chapter.subChapters) { subChapter in
                    ReaderTOCRow(
                        chapter: subChapter,
                        currentSpineHref: currentSpineHref,
                        onSelectChapter: onSelectChapter
                    )
                }
            } label: {
                chapterLabel
            }
            .listRowBackground(isCurrentChapter ? Color.accentColor.opacity(0.16) : Color.clear)
        }
    }

    private var chapterLabel: some View {
        Text(chapter.label)
            .font(.body)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, AppSpacing.xxs)
    }

    private var isCurrentChapter: Bool {
        normalizedPath(from: currentSpineHref) == normalizedPath(from: chapter.href.relativeString)
    }

    private func normalizedPath(from rawValue: String) -> String {
        let fragmentDropped = rawValue.split(separator: "#", maxSplits: 1).first.map(String.init) ?? rawValue

        if let url = URL(string: fragmentDropped),
           let host = url.host,
           host == "book" {
            return url.path
        }

        if let url = URL(string: fragmentDropped), !url.path.isEmpty {
            return url.path
        }

        return fragmentDropped
            .replacingOccurrences(of: "./", with: "")
            .replacingOccurrences(of: "%20", with: " ")
    }
}
