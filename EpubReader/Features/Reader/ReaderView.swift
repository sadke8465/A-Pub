import SwiftUI

public struct ReaderView: View {

    @StateObject private var viewModel: ReaderViewModel
    @State private var pageCurlVC: PageCurlViewController?

    public init(viewModel: ReaderViewModel = ReaderViewModel()) {
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
                        viewModel.toggleOverlay()
                    }
                }
                .onChange(of: viewModel.book?.identifier) { _, _ in
                    if !viewModel.escapedBase64Book.isEmpty {
                        pageCurlVC?.loadBook(escapedBase64: viewModel.escapedBase64Book)
                    }
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
                Button {
                    viewModel.loadFromFile()
                } label: {
                    Image(systemName: "folder")
                }
                .accessibilityLabel("Open EPUB")
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
                    pageCurlVC?.callJS("prevPage()")
                } label: {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.system(size: 36))
                }

                Button {
                    pageCurlVC?.callJS("nextPage()")
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
}

#Preview {
    NavigationStack {
        ReaderView()
    }
}
