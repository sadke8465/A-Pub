import SwiftUI

struct ReaderOverlay: View {

    @Binding var isVisible: Bool
    let chapterTitle: String
    let progressPercentage: Double
    let minutesLeft: Int?
    let autoHidePaused: Bool
    let onBack: () -> Void
    let onTableOfContents: () -> Void
    let onGoToLocation: () -> Void
    let onSettings: () -> Void

    @State private var autoHideTask: Task<Void, Never>?
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 0) {
            topBar
            Spacer(minLength: 0)
            bottomBar
        }
        .opacity(isVisible ? 1 : 0)
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: isVisible)
        .allowsHitTesting(isVisible)
        .onAppear {
            scheduleAutoHideIfNeeded()
        }
        .onChange(of: isVisible) { _, visible in
            if visible {
                scheduleAutoHideIfNeeded()
            } else {
                cancelAutoHide()
            }
        }
        .onChange(of: autoHidePaused) { _, paused in
            if paused {
                cancelAutoHide()
            } else {
                scheduleAutoHideIfNeeded()
            }
        }
        .onDisappear {
            cancelAutoHide()
        }
    }

    func userInteracted() {
        guard isVisible else {
            return
        }
        scheduleAutoHideIfNeeded()
    }

    private var topBar: some View {
        HStack(spacing: 8) {
            Button(action: {
                userInteracted()
                onBack()
            }) {
                Image(systemName: "chevron.left")
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Back to library")

            Text(chapterTitle)
                .font(.subheadline.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .frame(maxWidth: .infinity)
                .accessibilityLabel(chapterTitle)

            HStack(spacing: 4) {
                Button(action: {
                    userInteracted()
                    onTableOfContents()
                }) {
                    Image(systemName: "list.bullet")
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel("Contents")

                Button(action: {
                    userInteracted()
                    onGoToLocation()
                }) {
                    Image(systemName: "location")
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel("Go to location")

                Button(action: {
                    userInteracted()
                    onSettings()
                }) {
                    Image(systemName: "gearshape")
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel("Appearance")
            }
            .font(.headline)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 10)
        .background(.ultraThinMaterial)
    }

    private var bottomBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "book")
                .frame(width: 44, height: 44)

            Spacer(minLength: 0)

            Text(statusText)
                .font(.subheadline.monospacedDigit())
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Spacer(minLength: 0)

            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 12)
        .background(.ultraThinMaterial)
    }

    private func scheduleAutoHideIfNeeded() {
        guard isVisible, !autoHidePaused else {
            return
        }
        cancelAutoHide()
        autoHideTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(3))
            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
                isVisible = false
            }
        }
    }

    private func cancelAutoHide() {
        autoHideTask?.cancel()
        autoHideTask = nil
    }

    private var statusText: String {
        let percentText = "\(Int((progressPercentage * 100).rounded()))%"
        guard let minutesLeft, minutesLeft > 0 else {
            return percentText
        }
        return "\(percentText) · ~\(minutesLeft)m left"
    }
}
