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
    @State private var previousNavigationCFI: String?
    @State private var navigationConfirmation: String?
    @State private var footnotePayload: FootnotePayload?
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(viewModel: ReaderViewModel = ReaderViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ZStack {
            PageCurlReaderView(viewModel: viewModel) { vc in
                pageCurlVC = vc
                viewModel.attachPageCurlController(vc)
                vc.setReduceMotionEnabled(reduceMotion)
                vc.setRightToLeftReading(viewModel.isRightToLeftReading)
                vc.setReaderInteractionBlocked(isReaderControlActive)
                vc.onCenterTap = {
                    guard !isReaderControlActive else {
                        return
                    }
                    viewModel.toggleOverlay()
                }
                vc.onFootnoteRequest = { href, text in
                    footnotePayload = FootnotePayload(href: href, text: text)
                }
                loadCurrentBookIfPossible()
            }
            .ignoresSafeArea()
            .onChange(of: viewModel.book?.identifier) { _, _ in
                loadCurrentBookIfPossible()
            }

            ReaderOverlay(
                isVisible: $viewModel.isOverlayVisible,
                chapterTitle: currentChapterTitle,
                progressPercentage: viewModel.percentage,
                minutesLeft: viewModel.minutesRemainingInChapter > 0 ? viewModel.minutesRemainingInChapter : nil,
                autoHidePaused: isReaderControlActive,
                onBack: { dismiss() },
                onTableOfContents: { showingTOCPanel = true },
                onGoToLocation: {
                    goToPercentage = (viewModel.percentage * 100).clamped(to: 0...100)
                    goToPercentageText = String(Int(goToPercentage.rounded()))
                    showingGoToLocationSheet = true
                },
                onSettings: { showingAppearanceSettings = true }
            )

            if viewModel.isLoading || viewModel.readerStatusMessage != nil {
                ProgressView(viewModel.readerStatusMessage ?? "Opening...")
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
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

            if let navigationConfirmation {
                VStack {
                    Spacer()
                    HStack(spacing: 12) {
                        Text(navigationConfirmation)
                            .font(.footnote.weight(.semibold))
                        if previousNavigationCFI != nil {
                            Button("Back") {
                                returnToPreviousLocation()
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .padding(.bottom, 42)
                }
            }
        }
        .onAppear {
            viewModel.loadInitialBookIfNeeded()
            pageCurlVC?.setReduceMotionEnabled(reduceMotion)
            updateReaderInteractionBlock()
        }
        .onDisappear {
            viewModel.teardownReader()
        }
        .onChange(of: reduceMotion) { _, newValue in
            pageCurlVC?.setReduceMotionEnabled(newValue)
        }
        .onChange(of: viewModel.isRightToLeftReading) { _, isRightToLeft in
            pageCurlVC?.setRightToLeftReading(isRightToLeft)
        }
        .onChange(of: isReaderControlActive) { _, _ in
            updateReaderInteractionBlock()
        }
        .sheet(isPresented: $showingAppearanceSettings) {
            AppearanceSettings(
                appearance: viewModel.appearance,
                applyFontSize: { px in
                    pageCurlVC?.applyFontSize(px)
                    viewModel.handleAppearanceChange()
                },
                applyFontFamily: { family in
                    pageCurlVC?.applyFontFamily(family)
                    viewModel.handleAppearanceChange()
                },
                applyTheme: { theme in
                    pageCurlVC?.applyTheme(theme)
                    viewModel.handleAppearanceChange()
                },
                applyMargin: { px in
                    pageCurlVC?.applyMargin(px)
                    viewModel.handleAppearanceChange()
                },
                applyLineSpacing: { value in
                    pageCurlVC?.applyLineSpacing(value)
                    viewModel.handleAppearanceChange()
                },
                applyJustify: { justify in
                    pageCurlVC?.applyJustify(justify)
                    viewModel.handleAppearanceChange()
                },
                applyHyphenation: { on in
                    pageCurlVC?.applyHyphenation(on)
                    viewModel.handleAppearanceChange()
                },
                onAppearanceChanged: { viewModel.handleAppearanceChange() },
                onSaveAsDefaultForBook: { viewModel.saveCurrentAppearanceOverrideForCurrentBook() }
            )
        }
        .sheet(isPresented: $showingTOCPanel) {
            ReaderTOCPanel(
                chapters: viewModel.book?.spineItems ?? [],
                currentSpineHref: currentChapterHref,
                onSelectChapter: { chapter in
                    jumpToHref(chapter.href.relativeString)
                }
            )
            .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showingGoToLocationSheet) {
            goToLocationPanel
                .presentationDetents([.fraction(0.38), .medium])
        }
        .sheet(item: $footnotePayload) { footnote in
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(footnote.text.isEmpty ? "No footnote content available." : footnote.text)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                }
                .navigationTitle("Footnote")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    if !footnote.href.isEmpty {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Open") {
                                jumpToHref(footnote.href)
                                footnotePayload = nil
                            }
                        }
                    }
                }
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

    private func loadCurrentBookIfPossible() {
        guard let pageCurlVC, let bookFileURL = viewModel.bookFileURL else {
            return
        }

        pageCurlVC.loadBook(
            fileURL: bookFileURL,
            fallbackEscapedBase64: viewModel.legacyEscapedBase64Book.isEmpty
                ? nil
                : viewModel.legacyEscapedBase64Book
        )
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

    private var isReaderControlActive: Bool {
        showingAppearanceSettings
            || showingTOCPanel
            || showingGoToLocationSheet
            || footnotePayload != nil
            || scrubberDragPercentage != nil
    }

    private var scrubberView: some View {
        GeometryReader { geometry in
            let horizontalPadding: CGFloat = 20
            let trackWidth = max(geometry.size.width - (horizontalPadding * 2), 1)
            let activePercentage = activeScrubberPercentage.clamped(to: 0...1)
            let thumbX = horizontalPadding + (trackWidth * activePercentage)
            let isEnabled = viewModel.areLocationsReady

            VStack(spacing: 8) {
                if let dragPercentage = scrubberDragPercentage {
                    Text("\(Int((dragPercentage * 100).rounded()))% · \(chapterTitle(for: dragPercentage))")
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
                        .fill(Color.white.opacity(isEnabled ? 0.24 : 0.1))
                        .frame(height: 4)

                    ForEach(chapterTickFractions, id: \.self) { fraction in
                        Capsule()
                            .fill(Color.white.opacity(0.45))
                            .frame(width: 2, height: 10)
                            .offset(x: (trackWidth * fraction).clamped(to: 0...trackWidth))
                    }

                    Capsule()
                        .fill(Color.accentColor)
                        .opacity(isEnabled ? 1 : 0.35)
                        .frame(width: max(4, trackWidth * activePercentage), height: 4)
                }
                .frame(width: trackWidth, height: 36)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            guard isEnabled else { return }
                            let percentage = percentageFrom(
                                globalX: value.location.x,
                                frame: geometry.frame(in: .global),
                                horizontalPadding: horizontalPadding,
                                trackWidth: trackWidth
                            )
                            scrubberDragPercentage = percentage
                        }
                        .onEnded { value in
                            guard isEnabled else { return }
                            let percentage = percentageFrom(
                                globalX: value.location.x,
                                frame: geometry.frame(in: .global),
                                horizontalPadding: horizontalPadding,
                                trackWidth: trackWidth
                            )
                            scrubberDragPercentage = nil
                            jumpToPercentage(percentage)
                        }
                )
                .accessibilityLabel(isEnabled ? "Reading progress" : "Reading progress unavailable until pagination completes")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 6)
            .allowsHitTesting(isEnabled)
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private var chapterTickFractions: [Double] {
        guard let book = viewModel.book, book.spineItems.count > 1 else {
            return []
        }
        let count = min(book.spineItems.count, 24)
        return (1..<count).map { Double($0) / Double(count) }
    }

    private var goToLocationPanel: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 18) {
                Text("Move through the book")
                    .font(.headline)

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
                .disabled(!viewModel.areLocationsReady)

                HStack {
                    TextField("Percent", text: $goToPercentageText)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: goToPercentageText) { _, text in
                            let filtered = text.filter(\.isNumber)
                            if filtered != text {
                                goToPercentageText = filtered
                            }
                            if let value = Double(filtered) {
                                goToPercentage = value.clamped(to: 0...100)
                            }
                        }
                    Text("%")
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 8) {
                    quickJumpButton("Start", percentage: 0)
                    quickJumpButton("25", percentage: 25)
                    quickJumpButton("50", percentage: 50)
                    quickJumpButton("75", percentage: 75)
                    quickJumpButton("End", percentage: 100)
                }

                Button {
                    let clamped = goToPercentage.clamped(to: 0...100)
                    jumpToPercentage(clamped / 100.0)
                    showingGoToLocationSheet = false
                } label: {
                    Label("Go", systemImage: "arrow.right.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.areLocationsReady || goToPercentageText.isEmpty)

                if !viewModel.areLocationsReady {
                    Text("Pagination is finishing before location jumps are available.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .navigationTitle("Go to Location")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func quickJumpButton(_ title: String, percentage: Double) -> some View {
        Button(title) {
            goToPercentage = percentage
            goToPercentageText = String(Int(percentage))
        }
        .buttonStyle(.bordered)
        .disabled(!viewModel.areLocationsReady)
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

    private func updateReaderInteractionBlock() {
        pageCurlVC?.setReaderInteractionBlocked(isReaderControlActive)
        pageCurlVC?.setRightToLeftReading(viewModel.isRightToLeftReading)
        pageCurlVC?.setReduceMotionEnabled(reduceMotion)
    }

    private func jumpToPercentage(_ percentage: Double) {
        let clamped = percentage.clamped(to: 0...1)
        capturePreviousLocation()
        pageCurlVC?.displayPercentage(clamped)
        showNavigationConfirmation("Moved to \(Int((clamped * 100).rounded()))%")
    }

    private func jumpToHref(_ href: String) {
        guard !href.isEmpty else { return }
        capturePreviousLocation()
        pageCurlVC?.displayHref(href)
        showNavigationConfirmation("Moved")
    }

    private func returnToPreviousLocation() {
        guard let previousNavigationCFI else { return }
        pageCurlVC?.displayCFI(previousNavigationCFI)
        self.previousNavigationCFI = nil
        showNavigationConfirmation("Returned")
    }

    private func capturePreviousLocation() {
        if !viewModel.currentCFI.isEmpty {
            previousNavigationCFI = viewModel.currentCFI
        }
    }

    private func showNavigationConfirmation(_ message: String) {
        navigationConfirmation = message
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(4))
            if navigationConfirmation == message {
                navigationConfirmation = nil
            }
        }
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
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            Group {
                if chapters.isEmpty {
                    ContentUnavailableView("No Contents", systemImage: "list.bullet", description: Text("This EPUB does not provide a table of contents."))
                } else if visibleChapters.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                } else {
                    List {
                        ForEach(visibleChapters) { chapter in
                            chapterRow(chapter, depth: 0)
                        }
                    }
                }
            }
            .navigationTitle("Contents")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        }
    }

    private var visibleChapters: [EPUBChapter] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            return chapters
        }
        return chapters.compactMap { filteredChapter($0, query: query) }
    }

    private func filteredChapter(_ chapter: EPUBChapter, query: String) -> EPUBChapter? {
        let nested = chapter.subChapters.compactMap { filteredChapter($0, query: query) }
        if chapter.label.localizedCaseInsensitiveContains(query) || !nested.isEmpty {
            return EPUBChapter(
                id: chapter.id,
                href: chapter.href,
                mediaType: chapter.mediaType,
                label: chapter.label,
                subChapters: nested
            )
        }
        return nil
    }

    private func chapterRow(_ chapter: EPUBChapter, depth: Int) -> AnyView {
        if chapter.subChapters.isEmpty {
            return AnyView(Button {
                onSelectChapter(chapter)
                dismiss()
            } label: {
                chapterLabel(for: chapter, depth: depth)
            }
            .buttonStyle(.plain)
            .listRowBackground(isCurrentChapter(chapter) ? Color.accentColor.opacity(0.2) : Color.clear))
        } else {
            return AnyView(DisclosureGroup {
                ForEach(chapter.subChapters) { subChapter in
                    chapterRow(subChapter, depth: depth + 1)
                }
            } label: {
                chapterLabel(for: chapter, depth: depth)
            }
            .listRowBackground(isCurrentChapter(chapter) ? Color.accentColor.opacity(0.2) : Color.clear))
        }
    }

    private func chapterLabel(for chapter: EPUBChapter, depth: Int) -> some View {
        HStack(spacing: 8) {
            if isCurrentChapter(chapter) {
                Capsule()
                    .fill(Color.accentColor)
                    .frame(width: 4)
            }

            Text(chapter.label)
                .font(.body)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.leading, CGFloat(depth) * 14)
        .padding(.vertical, 6)
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
