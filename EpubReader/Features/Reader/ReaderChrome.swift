import SwiftUI

struct ReaderChrome: View {

    @Binding var isVisible: Bool
    let chapterTitle: String
    let progressPercentage: Double
    let minutesLeft: Int
    let onBack: () -> Void
    let onOpenBook: () -> Void
    let onTableOfContents: () -> Void
    let onGoToLocation: () -> Void
    let onSettings: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var autoHideTask: Task<Void, Never>?

    var body: some View {
        VStack(spacing: 0) {
            topControls
            Spacer(minLength: 0)
            readingStatus
        }
        .padding(.horizontal, AppSpacing.md)
        .safeAreaPadding(.top, AppSpacing.sm)
        .safeAreaPadding(.bottom, AppSpacing.lg)
        .opacity(isVisible ? 1 : 0)
        .scaleEffect(reduceMotion || isVisible ? 1 : 0.98, anchor: .top)
        .offset(y: reduceMotion || isVisible ? 0 : -8)
        .animation(reduceMotion ? .easeInOut(duration: 0.12) : AppMotion.readerChrome, value: isVisible)
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

    private var topControls: some View {
        HStack(alignment: .top, spacing: AppSpacing.sm) {
            readerButton(systemImage: "chevron.left", accessibilityLabel: "Back to library") {
                onBack()
            }

            Spacer(minLength: 0)

            HStack(spacing: AppSpacing.xs) {
                readerButton(systemImage: "folder", accessibilityLabel: "Open EPUB") {
                    onOpenBook()
                }

                readerButton(systemImage: "list.bullet", accessibilityLabel: "Table of contents") {
                    onTableOfContents()
                }

                readerButton(systemImage: "location", accessibilityLabel: "Go to location") {
                    onGoToLocation()
                }

                readerButton(systemImage: "textformat.size", accessibilityLabel: "Appearance") {
                    onSettings()
                }
            }
            .padding(AppSpacing.xxs)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: AppRadius.control, style: .continuous))
        }
    }

    private var readingStatus: some View {
        VStack(spacing: AppSpacing.xs) {
            Text(chapterTitle)
                .font(.subheadline.weight(.semibold))
                .lineLimit(1)
                .frame(maxWidth: .infinity)

            Text("\(Int((progressPercentage * 100).rounded()))% · \(max(minutesLeft, 1)) min left")
                .font(.footnote.monospacedDigit())
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .frame(maxWidth: 360)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: AppRadius.control, style: .continuous))
    }

    private func readerButton(
        systemImage: String,
        accessibilityLabel: String,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            userInteracted()
            action()
        } label: {
            Image(systemName: systemImage)
                .font(.headline)
                .frame(width: AppSize.readerControl, height: AppSize.readerControl)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.primary)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: AppRadius.control, style: .continuous))
        .accessibilityLabel(accessibilityLabel)
    }

    private func userInteracted() {
        guard isVisible else {
            return
        }
        scheduleAutoHideIfNeeded()
    }

    private func scheduleAutoHideIfNeeded() {
        guard isVisible else {
            return
        }
        cancelAutoHide()
        autoHideTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(3))
            withAnimation(reduceMotion ? .easeInOut(duration: 0.12) : AppMotion.readerChrome) {
                isVisible = false
            }
        }
    }

    private func cancelAutoHide() {
        autoHideTask?.cancel()
        autoHideTask = nil
    }
}
