import UIKit

final class ReaderSelectionMenuAnchorView: UIView {
    override var canBecomeFirstResponder: Bool {
        true
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        false
    }
}
