import SwiftUI

struct TOCPanel: View {

    let chapters: [EPUBChapter]
    let currentSpineHref: String
    let onSelectChapter: (EPUBChapter) -> Void

    var body: some View {
        ReaderTOCPanel(
            chapters: chapters,
            currentSpineHref: currentSpineHref,
            onSelectChapter: onSelectChapter
        )
    }
}
