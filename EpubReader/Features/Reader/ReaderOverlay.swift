import SwiftUI

struct ReaderOverlay: View {

    @Binding var isVisible: Bool
    let chapterTitle: String
    let progressPercentage: Double
    let minutesLeft: Int
    let onBack: () -> Void
    let onSearch: () -> Void
    let onTableOfContents: () -> Void
    let onGoToLocation: () -> Void
    let onSettings: () -> Void
    let onTextToSpeech: () -> Void

    @State private var autoHideTask: Task<Void, Never>?

    var body: some View {
        VStack(spacing: 0) {
            topBar
            Spacer(minLength: 0)
            bottomBar
        }
        .opacity(isVisible ? 1 : 0)
        .animation(.easeInOut(duration: 0.2), value: isVisible)
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
        HStack(spacing: 12) {
            Button(action: {
                userInteracted()
                onBack()
            }) {
                Label("Library", systemImage: "chevron.left")
                    .labelStyle(.titleAndIcon)
            }

            Spacer(minLength: 0)

            Text(chapterTitle)
                .font(.subheadline.weight(.semibold))
                .lineLimit(1)

            Spacer(minLength: 0)

            HStack(spacing: 16) {
                Button(action: {
                    userInteracted()
                    onSearch()
                }) {
                    Image(systemName: "magnifyingglass")
                }

                Button(action: {
                    userInteracted()
                    onTableOfContents()
                }) {
                    Image(systemName: "list.bullet")
                }

                Button(action: {
                    userInteracted()
                    onGoToLocation()
                }) {
                    Image(systemName: "location")
                }

                Button(action: {
                    userInteracted()
                    onSettings()
                }) {
                    Image(systemName: "gearshape")
                }
            }
            .font(.headline)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 10)
        .background(.ultraThinMaterial)
    }

    private var bottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "text.book")

            Spacer(minLength: 0)

            Text("\(Int(progressPercentage * 100))% · ~\(max(minutesLeft, 1))m left")
                .font(.subheadline.monospacedDigit())

            Spacer(minLength: 0)

            Button(action: {
                userInteracted()
                onTextToSpeech()
            }) {
                Image(systemName: "speaker.wave.2")
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 12)
        .background(.ultraThinMaterial)
    }

    private func scheduleAutoHideIfNeeded() {
        cancelAutoHide()
        autoHideTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(3))
            withAnimation(.easeInOut(duration: 0.2)) {
                isVisible = false
            }
        }
    }

    private func cancelAutoHide() {
        autoHideTask?.cancel()
        autoHideTask = nil
    }
}
