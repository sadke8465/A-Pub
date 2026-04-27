import SwiftUI

enum AppSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
}

enum AppRadius {
    static let cover: CGFloat = 6
    static let control: CGFloat = 8
    static let panel: CGFloat = 12
}

enum AppSize {
    static let minTapTarget: CGFloat = 44
    static let readerControl: CGFloat = 44
    static let toolbarControl: CGFloat = 44
}

enum AppCover {
    static let aspectRatio: CGFloat = 2.0 / 3.0
    static let listWidth: CGFloat = 50
}

enum AppMotion {
    static let readerChrome = Animation.spring(response: 0.28, dampingFraction: 0.86)
    static let layout = Animation.spring(response: 0.34, dampingFraction: 0.9)
    static let quickSettle = Animation.spring(response: 0.22, dampingFraction: 0.88)
    static let interactive = Animation.interactiveSpring(response: 0.24, dampingFraction: 0.82)
}

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
