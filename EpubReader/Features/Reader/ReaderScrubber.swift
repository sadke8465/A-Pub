import SwiftUI

struct ReaderScrubber: View {

    let isChromeVisible: Bool
    let progressPercentage: Double
    @Binding var dragPercentage: Double?
    let chapterTitleForPercentage: (Double) -> String
    let onScrubEnded: (Double) -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GeometryReader { geometry in
            let horizontalPadding: CGFloat = AppSpacing.lg
            let trackWidth = max(geometry.size.width - (horizontalPadding * 2), 1)
            let activePercentage = (dragPercentage ?? progressPercentage).clamped(to: 0...1)

            VStack(spacing: AppSpacing.xs) {
                if let dragPercentage {
                    Text(chapterTitleForPercentage(dragPercentage))
                        .font(.footnote.weight(.semibold))
                        .lineLimit(1)
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, AppSpacing.xs)
                        .background(.ultraThinMaterial, in: Capsule())
                        .transition(.opacity)
                }

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.secondary.opacity(0.25))
                        .frame(height: 4)

                    Capsule()
                        .fill(Color.accentColor)
                        .frame(width: max(4, trackWidth * activePercentage), height: 4)
                }
                .frame(width: trackWidth, height: AppSize.minTapTarget)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            dragPercentage = percentage(from: value.location.x, trackWidth: trackWidth)
                        }
                        .onEnded { value in
                            let percentage = percentage(from: value.location.x, trackWidth: trackWidth)
                            withAnimation(reduceMotion ? .easeInOut(duration: 0.12) : AppMotion.quickSettle) {
                                dragPercentage = nil
                            }
                            onScrubEnded(percentage)
                        }
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, AppSpacing.xs)
            .opacity(shouldShow ? 1 : 0)
            .offset(y: reduceMotion || shouldShow ? 0 : 10)
            .animation(reduceMotion ? .easeInOut(duration: 0.12) : AppMotion.readerChrome, value: shouldShow)
            .allowsHitTesting(shouldShow)
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private var shouldShow: Bool {
        isChromeVisible || dragPercentage != nil
    }

    private func percentage(from xPosition: CGFloat, trackWidth: CGFloat) -> Double {
        Double(xPosition.clamped(to: 0...trackWidth) / trackWidth)
    }
}
