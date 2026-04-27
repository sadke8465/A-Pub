import SwiftUI

struct BookProgressIndicator: View {

    let percentage: Double

    var body: some View {
        ProgressView(value: percentage.clamped(to: 0...1))
            .progressViewStyle(.linear)
            .tint(percentage >= 1 ? .green : .accentColor)
            .accessibilityLabel("Reading progress")
            .accessibilityValue("\(Int((percentage * 100).rounded())) percent")
    }
}
