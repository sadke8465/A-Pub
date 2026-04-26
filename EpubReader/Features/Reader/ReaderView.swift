import SwiftUI

public struct ReaderView: View {

    @StateObject private var viewModel: ReaderViewModel
    @State private var pageCurlVC: PageCurlViewController?
    @State private var showingAppearanceSettings = false
    @Environment(\.dismiss) private var dismiss

    init(viewModel: ReaderViewModel = ReaderViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                PageCurlReaderView(viewModel: viewModel) { vc in
                    pageCurlVC = vc
                }
                .ignoresSafeArea()
                // Swipe left → next page; swipe right → prev page.
                .simultaneousGesture(
                    DragGesture(minimumDistance: 30)
                        .onEnded { value in
                            if value.translation.width < -50 {
                                pageCurlVC?.callJS("nextPage()")
                            } else if value.translation.width > 50 {
                                pageCurlVC?.callJS("prevPage()")
                            }
                        }
                )
                // Zone-based tap: left 25% → prev, right 25% → next, centre → overlay.
                .onTapGesture(coordinateSpace: .local) { location in
                    let width = geometry.size.width
                    if location.x < width * 0.25 {
                        pageCurlVC?.callJS("prevPage()")
                    } else if location.x > width * 0.75 {
                        pageCurlVC?.callJS("nextPage()")
                    } else {
                        viewModel.isOverlayVisible.toggle()
                    }
                }
                .onChange(of: viewModel.book?.identifier) { _, _ in
                    if let bookFileURL = viewModel.bookFileURL {
                        pageCurlVC?.loadBook(
                            fileURL: bookFileURL,
                            fallbackEscapedBase64: viewModel.legacyEscapedBase64Book.isEmpty
                                ? nil
                                : viewModel.legacyEscapedBase64Book
                        )
                    }
                }

                ReaderOverlay(
                    isVisible: $viewModel.isOverlayVisible,
                    chapterTitle: currentChapterTitle,
                    progressPercentage: viewModel.percentage,
                    minutesLeft: 8,
                    onBack: { dismiss() },
                    onSearch: {},
                    onTableOfContents: {},
                    onSettings: { showingAppearanceSettings = true },
                    onTextToSpeech: {}
                )

                if viewModel.isLoading {
                    ProgressView("Importing…")
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                if let recoveryMessage = viewModel.recoveryMessage {
                    VStack {
                        Text(recoveryMessage)
                            .font(.footnote.weight(.semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .padding(.top, 12)
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadInitialBookIfNeeded()
        }
        .onDisappear {
            viewModel.teardownReader()
        }
        .sheet(isPresented: $showingAppearanceSettings) {
            AppearanceSettings(
                appearance: viewModel.appearance,
                bridge: pageCurlVC?.currentSlot.bridge ?? viewModel.bridge,
                onAppearanceChanged: { viewModel.handleAppearanceChange() },
                onSaveAsDefaultForBook: { viewModel.saveCurrentAppearanceOverrideForCurrentBook() }
            )
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.loadFromFile()
                } label: {
                    Image(systemName: "folder")
                }
                .accessibilityLabel("Open EPUB")
            }
        }
    }

    private var currentChapterTitle: String {
        guard let book = viewModel.book,
              book.spineItems.indices.contains(viewModel.currentSpineIndex)
        else {
            return "No Book Loaded"
        }
        return book.spineItems[viewModel.currentSpineIndex].label
    }
}

#Preview {
    NavigationStack {
        ReaderView()
    }
}
