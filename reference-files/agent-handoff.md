# Agent Handoff

Task: 3a.4-6 Restore highlights, highlight action sheet, and color changes
Started: 2026-04-27

## Goal
Persisted highlights should restore when a chapter loads, respond to taps with actions, delete immediately, and update color immediately while preserving the saved color across reloads.

## Completed Slices
- [x] Highlight restore JS bridge implemented in `EpubReader/Resources/reader.html`: chapter content hooks request highlights by spine href, `applyHighlights(json)` parses Swift payloads, and `addHighlight(cfiRange, colorClass, id)` renders persisted marks with stable IDs. Validation run: JS syntax pass, Xcode build pass.
- [x] Highlight bridge callbacks wired in `EpubReader/Features/Reader/PageCurlViewController.swift`: slots forward `requestHighlights` with the requesting slot index and can apply JSON payloads back to that slot. Validation run: Xcode build pass.
- [x] Typed highlight payloads added in `EpubReader/Features/Annotations/HighlightSnapshot.swift` and `EpubReader/Features/Annotations/HighlightRenderPayload.swift`; project file updated to compile them. Validation run: Xcode build pass.
- [x] Highlight persistence APIs expanded in `EpubReader/Features/Annotations/HighlightManager.swift`: create/update return snapshots, chapter fetch returns snapshots, and ID lookup supports tapped marks. Validation run: Xcode build pass.
- [x] Reader view model JSON and mutation methods added in `EpubReader/Features/Reader/ReaderViewModel.swift`: chapter highlight payload encoding, tapped highlight lookup, delete verification, and color update. Validation run: Xcode build pass.
- [x] Highlight tap actions added in `EpubReader/Features/Reader/ReaderView.swift`: `confirmationDialog` presents Copy Text, color change buttons, Delete, and a placeholder Edit Note action until the note task exists. Delete removes the persisted highlight then removes the current JS mark; color change updates persistence then re-renders the JS mark. Validation run: Xcode build pass.
- [x] Earlier 3a.2 and 3a.3 code remains in place: text selection menu, Copy/Look Up/Translate, highlight creation persistence, and immediate JS rendering with persisted highlight IDs. Validation run previously: JS syntax pass, Xcode build pass.
- [x] Reader rendering/menu regression fix: `ReaderViewModel` now publishes `legacyEscapedBase64Book` and `bookFileURL` before `book`, so `ReaderView` loads with the base64 fallback ready instead of timing out on the custom URL scheme; `reader.html` explicitly allows text selection in the host and content theme CSS. Validation run: JS syntax pass, Xcode build pass.
- [x] Page-curl first-two-pages loop fix: `PageCurlViewController` now records per-slot CFIs, treats the current visible slot as canonical, and syncs adjacent slots via `displayAdjacent(cfi, delta)` instead of blindly issuing `nextPage()`/`prevPage()` from stale slot state. The `atChapterEnd` blind prewarm was removed. Validation run: JS syntax pass, Xcode build pass.
- [x] Page-turn glitch stabilization: removed the SwiftUI drag gesture that was also calling `nextPage()`/`prevPage()` while `UIPageViewController` was handling the curl, added one-shot sync keys for adjacent slot CFI/direction pairs, and suppresses adjacent sync while a native page transition is in progress. Validation run: JS syntax pass, Xcode build pass.

## In Progress
- Manual simulator smoke for reader rendering, page progression, and 3a.2 through 3a.6. Next action: run the app in Simulator, open a known EPUB, confirm page curls do not rapidly flash/churn through unrelated text, confirm the console no longer shows dense repeated `displayAdjacent` spam during a single turn, then execute the remaining checks below before updating `reference-files/master-plan.md`.

## Remaining Slices
- [ ] Smoke 3a.2: select a word, confirm the menu appears near the selection with color options, tap Copy, and confirm the pasteboard contains the text.
- [ ] Smoke page curl regression: turn forward at least 5 pages and backward at least 3 pages; confirm content does not loop between the first two pages and progress continues to update.
- [ ] Smoke 3a.3: select text, tap yellow highlight, and confirm the selected text turns yellow immediately.
- [ ] Smoke 3a.4: create a highlight, navigate away to another chapter, return, and confirm the highlight is still visible.
- [ ] Smoke 3a.5: tap an existing highlight, confirm the action sheet appears, tap Delete, confirm it disappears immediately, reload the chapter, and confirm it stays gone.
- [ ] Smoke 3a.6: tap a highlight, change from yellow to blue, confirm it turns blue immediately, reload the chapter, and confirm it is still blue.
- [ ] If all checks pass, update `reference-files/master-plan.md`: mark `3a.2`, `3a.3`, `3a.4`, `3a.5`, and `3a.6` complete; set `LAST_COMPLETED = 3a.6`; set `NEXT_TASK = 3b.1`; increment `TASKS_DONE` from 39 to 44.

## Important Decisions
- Swift renders highlights only after Core Data persistence returns a `HighlightSnapshot`, so JS state follows the saved record.
- Restored and newly created JS highlights use the persisted UUID as the mark ID; this lets tapped marks resolve back to Core Data.
- The content hook asks Swift for highlights using `contents.section.href` when available, falling back to `contents.cfiBase`; if restore fails, first compare that value with the stored `spineHref`.
- SwiftUI `confirmationDialog` does not provide a nested submenu, so color changes are presented as direct "Change to Color" actions.
- Edit Note is intentionally a placeholder until the note editor task exists; the current task-level verification does not depend on note editing.

## Validation Status
- JS syntax: pass.
- Xcode build: pass.
- Simulator smoke: not run.

## Known Risks
- The restore path depends on JS chapter href normalization matching the Swift/Core Data `spineHref`; verify with Simulator before marking 3a.4 complete.
- `markClicked` should receive the persisted UUID from epub.js annotation data or the annotation element callback; if tapped highlights do not open the dialog, inspect the payload reaching `EPUBBridge`.
- Master plan tasks 3a.2 through 3a.6 remain unchecked because the manual smoke checks have not run.
