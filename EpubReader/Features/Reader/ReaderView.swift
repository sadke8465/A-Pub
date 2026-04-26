import SwiftUI

public struct ReaderView: View {

    @StateObject private var viewModel: ReaderViewModel
    @State private var pageCurlVC: PageCurlViewController?
    @State private var showingAppearanceSettings = false
    @State private var showingTOCPanel = false
    @State private var showingGoToLocationSheet = false
    @State private var goToLocationPercentage = 0.0
    @State private var goToLocationText = "0"
    @State private var showingFootnoteSheet = false
    @State private var footnoteTitle = "Footnote"
    @State private var footnoteText = ""
    @State private var scrubberDragPercentage: Double?
    @Environment(\.dismiss) private var dismiss

    init(viewModel: ReaderViewModel = ReaderViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                PageCurlReaderView(viewModel: viewModel) { vc in
                    pageCurlVC = vc
                    vc.onFootnoteRequest = { _, text, title in
                        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        footnoteTitle = title.isEmpty ? "Footnote" : title
                        footnoteText = trimmed
                        showingFootnoteSheet = true
                    }
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
                    minutesLeft: viewModel.minutesRemainingInChapter,
                    onBack: { dismiss() },
                    onSearch: {},
                    onTableOfContents: { showingTOCPanel = true },
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

                scrubberView

                if viewModel.isOverlayVisible {
                    goToLocationButton
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
        .sheet(isPresented: $showingTOCPanel) {
            TOCPanel(
                chapters: viewModel.book?.spineItems ?? [],
                currentSpineHref: currentChapterHref,
                onSelectChapter: { chapter in
                    let href = chapter.href.relativeString.replacingOccurrences(of: "'", with: "\\'")
                    pageCurlVC?.callJS("displayCFI('\(href)')")
                }
            )
            .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showingGoToLocationSheet) {
            goToLocationSheet
                .presentationDetents([.fraction(0.35)])
        }
        .sheet(isPresented: $showingFootnoteSheet) {
            footnoteSheet
                .presentationDetents([.fraction(0.3), .medium])
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

    private var currentChapterHref: String {
        guard let book = viewModel.book,
              book.spineItems.indices.contains(viewModel.currentSpineIndex)
        else {
            return ""
        }
        return book.spineItems[viewModel.currentSpineIndex].href.relativeString
    }

    private var currentChapterTitle: String {
        guard let book = viewModel.book,
              book.spineItems.indices.contains(viewModel.currentSpineIndex)
        else {
            return "No Book Loaded"
        }
        return book.spineItems[viewModel.currentSpineIndex].label
    }

    private var activeScrubberPercentage: Double {
        scrubberDragPercentage ?? viewModel.percentage
    }

    private var scrubberView: some View {
        GeometryReader { geometry in
            let horizontalPadding: CGFloat = 20
            let trackWidth = max(geometry.size.width - (horizontalPadding * 2), 1)
            let activePercentage = activeScrubberPercentage.clamped(to: 0...1)
            let thumbX = horizontalPadding + (trackWidth * activePercentage)

            VStack(spacing: 8) {
                if let dragPercentage = scrubberDragPercentage {
                    Text(chapterTitle(for: dragPercentage))
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .position(x: thumbX, y: 14)
                } else {
                    Spacer()
                        .frame(height: 28)
                }

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 4)

                    Capsule()
                        .fill(Color.accentColor)
                        .frame(width: max(4, trackWidth * activePercentage), height: 4)
                }
                .frame(width: trackWidth, height: 24)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let percentage = percentageFrom(
                                globalX: value.location.x,
                                frame: geometry.frame(in: .global),
                                horizontalPadding: horizontalPadding,
                                trackWidth: trackWidth
                            )
                            scrubberDragPercentage = percentage
                        }
                        .onEnded { value in
                            let percentage = percentageFrom(
                                globalX: value.location.x,
                                frame: geometry.frame(in: .global),
                                horizontalPadding: horizontalPadding,
                                trackWidth: trackWidth
                            )
                            scrubberDragPercentage = nil
                            pageCurlVC?.callJS("displayCFI(\(percentage))")
                        }
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 6)
            .allowsHitTesting(true)
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private var goToLocationButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    syncGoToInputsWithCurrentProgress()
                    showingGoToLocationSheet = true
                } label: {
                    Image(systemName: "target")
                        .font(.headline)
                        .padding(12)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .padding(.trailing, 20)
                .padding(.bottom, 46)
            }
        }
        .transition(.opacity)
    }

    private var goToLocationSheet: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Slider(
                    value: Binding(
                        get: { goToLocationPercentage },
                        set: { newValue in
                            let clamped = newValue.clamped(to: 0...100)
                            goToLocationPercentage = clamped
                            goToLocationText = String(Int(clamped.rounded()))
                        }
                    ),
                    in: 0...100
                )

                HStack(spacing: 10) {
                    TextField(
                        "Percent",
                        text: Binding(
                            get: { goToLocationText },
                            set: { newValue in
                                goToLocationText = newValue
                                let filtered = newValue.filter(\.isNumber)
                                if let parsed = Double(filtered) {
                                    goToLocationPercentage = parsed.clamped(to: 0...100)
                                }
                            }
                        )
                    )
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    Text("%")
                        .font(.headline)
                }

                Button("Go") {
                    let normalized = (goToLocationPercentage.clamped(to: 0...100)) / 100
                    pageCurlVC?.callJS("displayCFI(\(normalized))")
                    showingGoToLocationSheet = false
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            .navigationTitle("Go to location")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var footnoteSheet: some View {
        NavigationStack {
            ScrollView {
                Text(footnoteText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .navigationTitle(footnoteTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func syncGoToInputsWithCurrentProgress() {
        let pct = (viewModel.percentage * 100).clamped(to: 0...100)
        goToLocationPercentage = pct
        goToLocationText = String(Int(pct.rounded()))
    }

    private func percentageFrom(
        globalX: CGFloat,
        frame: CGRect,
        horizontalPadding: CGFloat,
        trackWidth: CGFloat
    ) -> Double {
        let originX = frame.minX + horizontalPadding
        let localX = (globalX - originX).clamped(to: 0...trackWidth)
        return Double(localX / trackWidth)
    }

    private func chapterTitle(for percentage: Double) -> String {
        guard let book = viewModel.book, !book.spineItems.isEmpty else {
            return "No Chapter"
        }
        let clamped = percentage.clamped(to: 0...1)
        let rawIndex = Int(floor(clamped * Double(book.spineItems.count)))
        let index = min(max(rawIndex, 0), book.spineItems.count - 1)
        return book.spineItems[index].label
    }
}

private extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

#Preview {
    NavigationStack {
        ReaderView()
    }
}
