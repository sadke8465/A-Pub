import SwiftUI

struct ReaderSelectionMenuPresenter: UIViewRepresentable {
    let selection: ReaderTextSelection?
    let onHighlightColor: (HighlightColor, ReaderTextSelection) -> Void
    let onCopy: (ReaderTextSelection) -> Void
    let onLookUp: (ReaderTextSelection) -> Void
    let onTranslate: (ReaderTextSelection) -> Void

    func makeUIView(context: Context) -> ReaderSelectionMenuAnchorView {
        let view = ReaderSelectionMenuAnchorView()
        view.backgroundColor = .clear
        context.coordinator.attach(to: view)
        return view
    }

    func updateUIView(_ uiView: ReaderSelectionMenuAnchorView, context: Context) {
        context.coordinator.update(
            selection: selection,
            onHighlightColor: onHighlightColor,
            onCopy: onCopy,
            onLookUp: onLookUp,
            onTranslate: onTranslate
        )
    }

    func makeCoordinator() -> ReaderSelectionMenuCoordinator {
        ReaderSelectionMenuCoordinator()
    }
}
