import SwiftUI

public struct ReaderView: View {

    @StateObject private var viewModel: ReaderViewModel
    @State private var pageCurlVC: PageCurlViewController?
    @State private var showingAppearanceSettings = false
    @State private var showingTOCPanel = false
    @State private var showingGoToLocationSheet = false
    @State private var scrubberDragPercentage: Double?
    @State private var goToPercentage: Double = 0
    @State private var goToPercentageText: String = "0"
    @State private var footnotePayload: FootnotePayload?
    @Environment(\.dismiss) private var dismiss

    init(viewModel: ReaderViewModel = ReaderViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                PageCurlReaderView(viewModel: viewModel) { vc in
                    pageCurlVC = vc
                    vc.onFootnoteRequest = { href, text in
                        footnotePayload = FootnotePayload(href: href, text: text)
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
                    onGoToLocation: {
                        goToPercentage = (viewModel.percentage * 100).clamped(to: 0...100)
                        goToPercentageText = String(Int(goToPercentage.rounded()))
                        showingGoToLocationSheet = true
                    },
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
            ReaderTOCPanel(
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
            NavigationStack {
                Form {
                    Section("Location") {
                        VStack(alignment: .leading, spacing: 12) {
                            Slider(
                                value: Binding(
                                    get: { goToPercentage },
                                    set: { newValue in
                                        goToPercentage = newValue
                                        goToPercentageText = String(Int(newValue.rounded()))
                                    }
                                ),
                                in: 0...100,
                                step: 1
                            )
                            Text("\(Int(goToPercentage.rounded()))%")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }

                        TextField("Percent", text: $goToPercentageText)
                            .keyboardType(.numberPad)
                            .onChange(of: goToPercentageText) { _, text in
                                let filtered = text.filter(\.isNumber)
                                if filtered != text {
                                    goToPercentageText = filtered
                                }
                                if let value = Double(filtered) {
                                    goToPercentage = value.clamped(to: 0...100)
                                }
                            }

                        Button("Go") {
                            let clamped = goToPercentage.clamped(to: 0...100)
                            pageCurlVC?.callJS("displayCFI(\(clamped / 100.0))")
                            showingGoToLocationSheet = false
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .navigationTitle("Go to Location")
                .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.fraction(0.3), .medium])
        }
        .sheet(item: $footnotePayload) { footnote in
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        if !footnote.href.isEmpty {
                            Text(footnote.href)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Text(footnote.text.isEmpty ? "No footnote content available." : footnote.text)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                }
                .navigationTitle("Footnote")
                .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.fraction(0.25), .medium])
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

private struct ReaderTOCPanel: View {

    let chapters: [EPUBChapter]
    let currentSpineHref: String
    let onSelectChapter: (EPUBChapter) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(chapters) { chapter in
                    chapterRow(chapter)
                }
            }
            .navigationTitle("Contents")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func chapterRow(_ chapter: EPUBChapter) -> AnyView {
        if chapter.subChapters.isEmpty {
            return AnyView(Button {
                onSelectChapter(chapter)
                dismiss()
            } label: {
                chapterLabel(for: chapter)
            }
            .buttonStyle(.plain)
            .listRowBackground(isCurrentChapter(chapter) ? Color.accentColor.opacity(0.2) : Color.clear))
        } else {
            return AnyView(DisclosureGroup {
                ForEach(chapter.subChapters) { subChapter in
                    chapterRow(subChapter)
                }
            } label: {
                chapterLabel(for: chapter)
            }
            .listRowBackground(isCurrentChapter(chapter) ? Color.accentColor.opacity(0.2) : Color.clear))
        }
    }

    private func chapterLabel(for chapter: EPUBChapter) -> some View {
        Text(chapter.label)
            .font(.body)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
    }

    private func isCurrentChapter(_ chapter: EPUBChapter) -> Bool {
        normalizedPath(from: currentSpineHref) == normalizedPath(from: chapter.href.relativeString)
    }

    private func normalizedPath(from rawValue: String) -> String {
        let fragmentDropped = rawValue.split(separator: "#", maxSplits: 1).first.map(String.init) ?? rawValue

        if let url = URL(string: fragmentDropped),
           let host = url.host,
           host == "book" {
            return url.path
        }

        if let url = URL(string: fragmentDropped), !url.path.isEmpty {
            return url.path
        }

        return fragmentDropped
            .replacingOccurrences(of: "./", with: "")
            .replacingOccurrences(of: "%20", with: " ")
    }
}

private struct FootnotePayload: Identifiable {
    let id = UUID()
    let href: String
    let text: String
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
