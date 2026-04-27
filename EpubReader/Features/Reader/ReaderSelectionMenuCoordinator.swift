import UIKit

@MainActor
final class ReaderSelectionMenuCoordinator: NSObject, @MainActor UIEditMenuInteractionDelegate {
    private weak var anchorView: UIView?
    private var interaction: UIEditMenuInteraction?
    private var selection: ReaderTextSelection?
    private var presentedSelectionID: UUID?
    private var onHighlightColor: ((HighlightColor, ReaderTextSelection) -> Void)?
    private var onCopy: ((ReaderTextSelection) -> Void)?
    private var onLookUp: ((ReaderTextSelection) -> Void)?
    private var onTranslate: ((ReaderTextSelection) -> Void)?

    func attach(to anchorView: UIView) {
        self.anchorView = anchorView
        let interaction = UIEditMenuInteraction(delegate: self)
        self.interaction = interaction
        anchorView.addInteraction(interaction)
    }

    func update(
        selection: ReaderTextSelection?,
        onHighlightColor: @escaping (HighlightColor, ReaderTextSelection) -> Void,
        onCopy: @escaping (ReaderTextSelection) -> Void,
        onLookUp: @escaping (ReaderTextSelection) -> Void,
        onTranslate: @escaping (ReaderTextSelection) -> Void
    ) {
        self.selection = selection
        self.onHighlightColor = onHighlightColor
        self.onCopy = onCopy
        self.onLookUp = onLookUp
        self.onTranslate = onTranslate

        guard let selection, selection.id != presentedSelectionID else {
            return
        }

        presentedSelectionID = selection.id
        presentMenu(for: selection)
    }

    func editMenuInteraction(
        _ interaction: UIEditMenuInteraction,
        menuFor configuration: UIEditMenuConfiguration,
        suggestedActions: [UIMenuElement]
    ) -> UIMenu? {
        guard let selection else {
            return nil
        }

        let highlightActions = HighlightColor.allCases.map { color in
            UIAction(title: color.rawValue.capitalized) { [weak self] _ in
                self?.onHighlightColor?(color, selection)
            }
        }

        return UIMenu(children: [
            UIMenu(
                title: "Highlight",
                image: UIImage(systemName: "highlighter"),
                children: highlightActions
            ),
            UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { [weak self] _ in
                self?.onCopy?(selection)
            },
            UIAction(title: "Look Up", image: UIImage(systemName: "magnifyingglass")) { [weak self] _ in
                self?.onLookUp?(selection)
            },
            UIAction(title: "Translate", image: UIImage(systemName: "character.book.closed")) { [weak self] _ in
                self?.onTranslate?(selection)
            }
        ])
    }

    func editMenuInteraction(
        _ interaction: UIEditMenuInteraction,
        targetRectFor configuration: UIEditMenuConfiguration
    ) -> CGRect {
        selection?.rect ?? .zero
    }

    private func presentMenu(for selection: ReaderTextSelection) {
        guard let anchorView, let interaction else {
            return
        }

        anchorView.becomeFirstResponder()
        let sourcePoint = CGPoint(x: selection.rect.midX, y: selection.rect.midY)
        let configuration = UIEditMenuConfiguration(
            identifier: selection.id.uuidString as NSString,
            sourcePoint: sourcePoint
        )
        interaction.presentEditMenu(with: configuration)
    }
}
