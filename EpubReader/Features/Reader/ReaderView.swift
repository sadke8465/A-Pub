import SwiftUI
import UIKit

public struct ReaderView: View {

    @StateObject private var viewModel: ReaderViewModel
    @State private var pageCurlVC: PageCurlViewController?
    @State private var showingAppearanceSettings = false
    @State private var showingTOCPanel = false
    @State private var showingGoToLocationSheet = false
    @State private var scrubberDragPercentage: Double?
    @State private var footnotePayload: FootnotePayload?
    @State private var textSelection: ReaderTextSelection?
    @State private var activeHighlight: HighlightSnapshot?
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
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
                    vc.onRequestHighlights = { spineHref, slotIndex in
                        Task {
                            guard let json = await viewModel.highlightsJSON(for: spineHref) else {
                                return
                            }
                            vc.applyHighlights(json, to: slotIndex)
                        }
                    }
                    vc.onMarkClicked = { id in
                        Task {
                            activeHighlight = await viewModel.highlightSnapshot(idString: id)
                        }
                    }
                    vc.onSelected = { selection in
                        textSelection = selection
                    }
                }
                .ignoresSafeArea()
                // Zone-based tap: left 25% → prev, right 25% → next, centre → overlay.
                .onTapGesture(coordinateSpace: .local) { location in
                    let width = geometry.size.width
                    if location.x < width * 0.25 {
                        pageCurlVC?.callJS("prevPage()")
                    } else if location.x > width * 0.75 {
                        pageCurlVC?.callJS("nextPage()")
                    } else {
                        withAnimation(reduceMotion ? .easeInOut(duration: 0.12) : AppMotion.readerChrome) {
                            viewModel.isOverlayVisible.toggle()
                        }
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

                ReaderChrome(
                    isVisible: $viewModel.isOverlayVisible,
                    chapterTitle: currentChapterTitle,
                    progressPercentage: viewModel.percentage,
                    minutesLeft: viewModel.minutesRemainingInChapter,
                    onBack: { dismiss() },
                    onOpenBook: { viewModel.loadFromFile() },
                    onTableOfContents: { showingTOCPanel = true },
                    onGoToLocation: {
                        showingGoToLocationSheet = true
                    },
                    onSettings: { showingAppearanceSettings = true }
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

                ReaderScrubber(
                    isChromeVisible: viewModel.isOverlayVisible,
                    progressPercentage: viewModel.percentage,
                    dragPercentage: $scrubberDragPercentage,
                    chapterTitleForPercentage: chapterTitle(for:),
                    onScrubEnded: { percentage in
                        pageCurlVC?.callJS("displayCFI(\(percentage))")
                    }
                )

                ReaderSelectionMenuPresenter(
                    selection: textSelection,
                    onHighlightColor: selectHighlightColor(_:for:),
                    onCopy: copySelectedText(_:),
                    onLookUp: lookUpSelectedText(_:),
                    onTranslate: translateSelectedText(_:)
                )
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                applyFontSize: { px in pageCurlVC?.applyFontSize(px) },
                applyFontFamily: { family in pageCurlVC?.applyFontFamily(family) },
                applyTheme: { theme in pageCurlVC?.applyTheme(theme) },
                applyMargin: { px in pageCurlVC?.applyMargin(px) },
                applyLineSpacing: { value in pageCurlVC?.applyLineSpacing(value) },
                applyJustify: { justify in pageCurlVC?.applyJustify(justify) },
                applyHyphenation: { on in pageCurlVC?.applyHyphenation(on) },
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
            GoToLocationSheet(currentPercentage: viewModel.percentage) { percentage in
                pageCurlVC?.callJS("displayCFI(\(percentage))")
            }
        }
        .sheet(item: $footnotePayload) { footnote in
            FootnoteSheet(footnote: footnote)
        }
        .confirmationDialog(
            "Highlight",
            isPresented: Binding(
                get: { activeHighlight != nil },
                set: { isPresented in
                    if !isPresented {
                        activeHighlight = nil
                    }
                }
            ),
            titleVisibility: .visible,
            presenting: activeHighlight
        ) { highlight in
            Button("Edit Note") {
                Log.shared.info("Note editor is not available until task 3b.1")
            }
            Button("Copy Text") {
                copyHighlightedText(highlight)
            }
            ForEach(HighlightColor.allCases) { color in
                Button("Change to \(color.rawValue.capitalized)") {
                    changeHighlightColor(highlight, to: color)
                }
            }
            Button("Delete", role: .destructive) {
                deleteHighlight(highlight)
            }
            Button("Cancel", role: .cancel) {
                activeHighlight = nil
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

    private func chapterTitle(for percentage: Double) -> String {
        guard let book = viewModel.book, !book.spineItems.isEmpty else {
            return "No Chapter"
        }
        let clamped = percentage.clamped(to: 0...1)
        let rawIndex = Int(floor(clamped * Double(book.spineItems.count)))
        let index = min(max(rawIndex, 0), book.spineItems.count - 1)
        return book.spineItems[index].label
    }

    private func selectHighlightColor(_ color: HighlightColor, for selection: ReaderTextSelection) {
        Task {
            guard let highlight = await viewModel.createHighlight(
                from: selection,
                color: color,
                spineHref: currentChapterHref
            ) else {
                return
            }

            let escapedCFIRange = javaScriptStringLiteral(highlight.cfiRange)
            let escapedColorClass = javaScriptStringLiteral(color.cssClass)
            let escapedID = javaScriptStringLiteral(highlight.id.uuidString)
            pageCurlVC?.callJS("addHighlight('\(escapedCFIRange)', '\(escapedColorClass)', '\(escapedID)')")
            textSelection = nil
        }
    }

    private func copyHighlightedText(_ highlight: HighlightSnapshot) {
        UIPasteboard.general.string = highlight.selectedText
        activeHighlight = nil
    }

    private func deleteHighlight(_ highlight: HighlightSnapshot) {
        Task {
            let deleted = await viewModel.deleteHighlight(highlight)
            guard deleted else {
                return
            }
            let escapedCFIRange = javaScriptStringLiteral(highlight.cfiRange)
            pageCurlVC?.callJS("removeHighlight('\(escapedCFIRange)')")
            activeHighlight = nil
        }
    }

    private func changeHighlightColor(_ highlight: HighlightSnapshot, to color: HighlightColor) {
        Task {
            guard let updated = await viewModel.updateHighlightColor(highlight, color: color) else {
                return
            }
            let escapedCFIRange = javaScriptStringLiteral(updated.cfiRange)
            let escapedColorClass = javaScriptStringLiteral(updated.color.cssClass)
            let escapedID = javaScriptStringLiteral(updated.id.uuidString)
            pageCurlVC?.callJS("removeHighlight('\(escapedCFIRange)')")
            pageCurlVC?.callJS("addHighlight('\(escapedCFIRange)', '\(escapedColorClass)', '\(escapedID)')")
            activeHighlight = nil
        }
    }

    private func copySelectedText(_ selection: ReaderTextSelection) {
        UIPasteboard.general.string = selection.text
    }

    private func lookUpSelectedText(_ selection: ReaderTextSelection) {
        let term = selection.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: term),
              let presenter = activePresenter()
        else {
            return
        }
        presenter.present(UIReferenceLibraryViewController(term: term), animated: true)
    }

    private func translateSelectedText(_ selection: ReaderTextSelection) {
        let term = selection.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let encoded = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://translate.google.com/?sl=auto&tl=en&text=\(encoded)&op=translate")
        else {
            return
        }
        UIApplication.shared.open(url)
    }

    private func activePresenter() -> UIViewController? {
        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
        guard var presenter = scene?.windows.first(where: \.isKeyWindow)?.rootViewController else {
            return nil
        }

        while let presented = presenter.presentedViewController {
            presenter = presented
        }
        return presenter
    }

    private func javaScriptStringLiteral(_ value: String) -> String {
        value
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "'", with: "\\'")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\r", with: "\\r")
            .replacingOccurrences(of: "\u{2028}", with: "\\u2028")
            .replacingOccurrences(of: "\u{2029}", with: "\\u2029")
    }
}

#Preview {
    NavigationStack {
        ReaderView()
    }
}
