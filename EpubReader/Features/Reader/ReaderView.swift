import SwiftUI

public struct ReaderView: View {

    @StateObject private var viewModel: ReaderViewModel

    public init(viewModel: ReaderViewModel = ReaderViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ZStack {
            EPUBWebView(bridge: viewModel.bridge, onWebViewReady: viewModel.webViewReady)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.toggleOverlay()
                }
                .onChange(of: viewModel.escapedBase64Book) { _, newValue in
                    viewModel.hasPendingBookPayload = !newValue.isEmpty
                    viewModel.tryLoadBookIntoWebView()
                }

            if viewModel.isOverlayVisible {
                overlay
                    .transition(.opacity)
            }

            if viewModel.isLoading {
                ProgressView("Importing…")
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            if !viewModel.readerErrorMessage.isEmpty {
                readerErrorPanel
                    .padding()
            }
        }
        .onAppear {
            viewModel.loadInitialBookIfNeeded()
        }
        .onDisappear {
            viewModel.teardownReader()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Open EPUB") {
                    viewModel.loadFromFile()
                }
            }
        }
    }

    private var overlay: some View {
        VStack {
            HStack(spacing: 12) {
                Image(systemName: "chevron.backward")
                    .font(.headline)

                Text(currentChapterTitle)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)

                Spacer()

                Text("\(Int(viewModel.percentage * 100))%")
                    .font(.subheadline.monospacedDigit())
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)

            Spacer()

            HStack(spacing: 20) {
                Button {
                    viewModel.bridge.callJS("prevPage()")
                } label: {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.system(size: 36))
                }

                Button {
                    viewModel.bridge.callJS("nextPage()")
                } label: {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.system(size: 36))
                }
            }
            .padding(.bottom, 24)
        }
        .foregroundStyle(.white)
    }

    private var currentChapterTitle: String {
        guard let book = viewModel.book,
              book.spineItems.indices.contains(viewModel.currentSpineIndex)
        else {
            return "No Book Loaded"
        }

        return book.spineItems[viewModel.currentSpineIndex].label
    }

    private var readerErrorPanel: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title2)
                .foregroundStyle(.yellow)

            Text("Reader Error")
                .font(.headline)

            Text(viewModel.readerErrorMessage)
                .font(.subheadline)
                .multilineTextAlignment(.center)

            Button("Retry") {
                viewModel.retryAfterError()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 8)
    }
}

#Preview {
    NavigationStack {
        ReaderView()
    }
}
