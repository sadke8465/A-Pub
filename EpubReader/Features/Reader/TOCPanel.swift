import SwiftUI

struct TOCPanel: View {

    let chapters: [EPUBChapter]
    let currentSpineHref: String
    let onSelectChapter: (EPUBChapter) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(chapters) { chapter in
                    chapterRow(chapter)
                }
            }
            .navigationTitle("Contents")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func chapterRow(_ chapter: EPUBChapter) -> AnyView {
        if chapter.subChapters.isEmpty {
            return AnyView(Button {
                onSelectChapter(chapter)
                dismiss()
            } label: {
                chapterLabel(for: chapter)
            }
            .buttonStyle(.plain)
            .listRowBackground(isCurrentChapter(chapter) ? Color.accentColor.opacity(0.2) : Color.clear))
        } else {
            return AnyView(DisclosureGroup {
                ForEach(chapter.subChapters) { subChapter in
                    chapterRow(subChapter)
                }
            } label: {
                chapterLabel(for: chapter)
            }
            .listRowBackground(isCurrentChapter(chapter) ? Color.accentColor.opacity(0.2) : Color.clear))
        }
    }

    private func chapterLabel(for chapter: EPUBChapter) -> some View {
        Text(chapter.label)
            .font(.body)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
    }

    private func isCurrentChapter(_ chapter: EPUBChapter) -> Bool {
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
