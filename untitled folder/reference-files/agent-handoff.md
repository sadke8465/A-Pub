# Agent Handoff

Task: Fix Phase 2a Native Page Curl Slot Loading
Started: 2026-04-27

## Goal
Make native page curl use exactly three WKWebView slots that load from the base64 EPUB path sequentially and only curl after adjacent slots are synced to the current canonical CFI.

## Completed Slices
- [x] Read `agents.md`, `reference-files/master-plan.md`, `reference-files/epubjs-wkwebview-knowledge-base.md`, existing handoff, architecture mismatches, and current reader code.
- [x] Updated `EpubReader/Features/Reader/PageCurlViewController.swift` so the current slot loads first, adjacent loading starts after current relocation/book readiness, next slot loads/syncs before previous slot, and background slots keep the same base64 fallback as the visible slot.
- [x] Added stateful page-curl diagnostics: `adjacentLoadStarted`, `adjacentBookReady`, `adjacentSyncStarted`, `adjacentSyncCompleted`, `turnQueuedWhileSyncing`, `nativeCurlStarted`, `nativeCurlCompleted`, and `adjacentSyncFailed`.
- [x] Added queued tap turns while an adjacent target is loading or syncing; the queued turn is attempted immediately after the target sync completes.
- [x] Added retry-once adjacent recovery by reloading the failed adjacent slot with the base64-capable `PendingLoad`; final failure keeps that direction blocked and logs `retryExhausted`.
- [x] Fixed page-curl rendition sizing to use `view.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom`.
- [x] Removed the force unwrap in `EPUBFileSchemeHandler.register` and replaced it with a guarded precondition failure.
- [x] Updated `EpubReader/Resources/reader.html` so `displayAdjacent` is timeout-bounded and reports adjacent sync start/completion/failure diagnostics.

## In Progress
- Manual simulator smoke. Next action: run the app in Simulator, open a known EPUB, and verify native page curl and adjacent sync logs.

## Remaining Slices
- [ ] Smoke open/restore: readable text appears, `bookReady`, `relocated`, saved CFI restore, and generated or loaded locations.
- [ ] Smoke adjacent loading: next and previous slots both show `hasFallbackBase64:true` and reach `adjacentSyncCompleted`; no `book.opened URL timed out` appears.
- [ ] Smoke native page turns: tap forward/back and edge-drag forward/back; confirm native page curl appears and queued taps complete after sync.
- [ ] Smoke adjacency correctness: reverse direction after several turns and cross chapter boundaries without blank, stale, or stuck pages.
- [ ] Smoke navigation flows: TOC, scrubber, go-to-location, footnotes, and restore saved CFI.
- [ ] Smoke annotations and appearance: text selection, highlight create/restore/delete/color change, theme/font/spacing/margin reflow, and rotation resize/resync.
- [ ] Update `reference-files/master-plan.md` only after the full simulator smoke checklist passes.

## Important Decisions
- Background slots now receive the same `PendingLoad` as the current slot, preserving base64 loading as the primary path and leaving `epubreader-book://...` only as fallback if base64 fails or is absent.
- Initial adjacent loading is deferred when a restore/display call is pending, so restored CFI relocation can become the canonical CFI before adjacent slots sync.
- Initial adjacent load order is next then previous; the previous slot is not loaded until the next slot finishes sync or exhausts retry.
- Interactive page-curl data-source requests remain blocked until a matching synced slot exists; only explicit tap-zone turns queue one pending direction.

## Validation Status
- JS syntax: pass.
- Xcode build: pass. Only the known AppIntents metadata warning appeared.
- Simulator smoke: not run.

## Known Risks
- Manual smoke is still required to prove actual UIPageViewController curl behavior, real EPUB content correctness, and logs from device runtime.
- The worktree still contains unrelated pre-existing changes outside this slice, including `.DS_Store`, Xcode user state, `console-log.txt`, a deleted `Reference files/architecture-mismatches.md`, and untracked skill files.
