# Agent Handoff

Task: 2d.1 Reader UX polish pass
Started: 2026-04-26

## Goal
Make Step 2 reading, appearance, navigation, and footnote flows feel designed, usable, intuitive, and frictionless for daily reading.

## Completed Slices
- [x] Page-turn guards and reader state, files changed: `Features/Reader/PageCurlViewController.swift`, `Features/Reader/ReaderViewModel.swift`, `Features/Reader/ReaderView.swift`; JS syntax pass, Xcode build pass.
- [x] Overlay polish, files changed: `Features/Reader/ReaderOverlay.swift`, `Features/Reader/ReaderView.swift`; JS syntax pass, Xcode build pass.
- [x] Scrubber, go-to-location, and TOC polish, files changed: `Features/Reader/ReaderView.swift`; JS syntax pass, Xcode build pass.
- [x] Appearance panel polish, files changed: `Features/Settings/AppearanceSettings.swift`; JS syntax pass, Xcode build pass.
- [x] Footnote and selection JS polish, files changed: `Resources/reader.html`, `Features/Reader/PageCurlViewController.swift`; JS syntax pass, Xcode build pass.

## In Progress
- Runtime simulator smoke is still required before marking `2d.1` complete in `master-plan.md`.

## Remaining Slices
- [ ] Run or request simulator smoke with at least one known EPUB and one footnote EPUB.
- [ ] Update `master-plan.md` only after simulator smoke passes.

## Important Decisions
- RTL page-turn direction is driven from EPUB language metadata because `EPUBBook` does not currently expose OPF spine `page-progression-direction`.
- Search and TTS overlay buttons were removed from visible chrome because their handlers were empty in the current code.
- Scrubber jumps are disabled until the JS locations snapshot reports at least one generated location.

## Validation Status
- JS syntax: pass.
- Xcode build: pass.
- Simulator smoke: not run.

## Known Risks
- Cross-file footnote resolution depends on epub.js section loading behavior for the target EPUB.
