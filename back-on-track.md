# Back On Track Plan

Audit date: 2026-04-26

## Current Master Plan Position

The master plan still says:

- `LAST_COMPLETED = 2c.4`
- `NEXT_TASK = 2c.5`
- Current milestone: Phase 2c, overlays and navigation

The master-plan smoke gate is now partially restored, but not complete:

1. Import a known EPUB: passing.
2. First readable text appears: passing.
3. `bookReady` appears: passing.
4. At least one `relocated` callback updates CFI and percentage: CFI passes, percentage does not yet meaningfully update.
5. Next/previous page works: failing from the user-visible reader.

Do not mark 2c.5 complete or advance Phase 3 until paging works reliably.

## Updated Console Log Finding

The blank-text blocker is fixed. The latest log proves:

- `book.opened resolved`
- `book.ready resolved`
- spine sampling works
- first readable text is found
- `rendition.display resolved`
- `rendered` fires
- `relocated` fires
- iframe text is non-empty
- `bookReady sent`

Key evidence:

- Initial target selected: `text/public-domain.xhtml`
- First visible text length: `552`
- Next section render text length: `12451`
- `relocated` moves from `text/public-domain.xhtml` to `text/introduction.xhtml`

The active failure is now navigation state, not rendering.

## Current Failure

The app shows text, but page turns do not progress as a real book. The console repeatedly shows page turns landing on:

- `text/public-domain.xhtml`, displayed page `1` of `1`
- `text/introduction.xhtml`, displayed page `1` of `10`

There is no evidence of advancing to introduction displayed page 2, 3, 4, etc. So the app is not turning pages inside the currently visible chapter. It is mostly bouncing between the first readable one-page section and the first page of the next section.

## Root Causes

### 1. PageCurl Pool Has No Real Page Model

Each WKWebView slot loads the same initial target. Adjacent slots are loaded, but they are not assigned precise previous/current/next page CFIs.

Current behavior:

- Slot 1 loads initial readable page.
- Slots 0 and 2 also load the same initial readable page.
- On page curl rotation, recycled slots are nudged with blind `nextPage()` or `prevPage()`.
- Those nudges operate from each slot's own stale state, not from the canonical current reader position.

This means any slot can appear with old content, or with only the first page of the next section.

### 2. SwiftUI Gestures And UIPageViewController Gestures Compete

`ReaderView` adds a SwiftUI `DragGesture` that calls `pageCurlVC?.callJS("nextPage()")` / `prevPage()`.

`PageCurlViewController` also owns a UIKit page-curl gesture through `UIPageViewController`.

Those two mechanisms can both respond to the same user action:

- SwiftUI may tell the current slot's epub.js rendition to move.
- UIKit may simultaneously transition to a different WKWebView slot.
- After the transition, `poolCurrent` may point to a slot that did not receive the JS navigation command.

This explains why logs show real JS movement while the visible page appears stuck.

### 3. `nextPage()` Is Being Sent To Different Slots

The log shows navigation and render-state events from slots 0, 1, and 2. Each slot has its own epub.js rendition and its own location.

Because the pool does not keep a canonical location and explicit target per slot, repeated user turns are not guaranteed to call `nextPage()` on the slot that is actually visible after the curl completes.

### 4. Progress Percentage Is Still Zero

`relocated` now fires, but `percentage` remains `0`. That means `book.locations` is not loaded/generated before progress calculations.

The master plan requires `relocated` to update percentage, and Phase 2b requires location cache behavior. CFI is now available, but percentage is not.

### 5. Initial Readable Target Is Too Early For User Expectations

The current heuristic selects `text/public-domain.xhtml` because it has 550 readable characters. This is technically readable, but it is a front-matter/legal page, not the first meaningful reading section.

For `Frankenstein.epub`, the first durable target should likely be the first TOC target or a stronger text threshold, not the first section with 80+ characters.

## Recovery Plan

### Phase 0 - Stabilize The Reader Before More Features

Freeze Phase 2c advancement until:

- Current slot can move from introduction page 1 to page 2 to page 3.
- UI page turn gesture and tap zones use one navigation path.
- CFI and percentage update on every turn.
- TOC, scrubber, and go-to-location target the visible slot.

Keep master-plan invariants:

- Max 3 WKWebViews.
- Shared `WKProcessPool`.
- `LeakAvoider` bridge.
- Remove script handlers on teardown.
- Handle WebContent termination.
- Xcode CLI build must pass.

### Phase 1 - Remove Gesture Competition

Make one navigation owner.

Immediate implementation:

1. Disable the SwiftUI `DragGesture` that directly calls `nextPage()` / `prevPage()`.
2. Disable tap-zone page turns temporarily, or route them through explicit `PageCurlViewController` methods.
3. Add public methods:
   - `turnForward()`
   - `turnBackward()`
4. Those methods should own both the visual transition and the epub.js page movement.

Acceptance:

- One user swipe produces one navigation action.
- Logs show one slot receiving the command.
- The visible slot and the logged slot match.

### Phase 2 - Prove Single-Slot Paging First

Before fixing three-slot curl, prove epub.js can page correctly in one visible WKWebView.

Implementation:

1. Add a temporary debug mode in `PageCurlViewController`:
   - keep only `currentSlot` visible
   - ignore `UIPageViewControllerDataSource`
   - call `nextPage()` / `prevPage()` only on `currentSlot`
2. On every page turn, log:
   - slot index
   - source command
   - spine href
   - displayed page
   - displayed total
   - CFI
   - text excerpt

Acceptance:

- Repeated next actions produce:
  - `text/introduction.xhtml` page 1 of 10
  - page 2 of 10
  - page 3 of 10
- If this fails, the bug is JS/epub.js navigation.
- If this passes, the bug is PageCurl slot synchronization.

### Phase 3 - Make Current Slot The Canonical Source Of Truth

Maintain one canonical reader location in `PageCurlViewController`.

Add state:

- `currentLocation`
- `currentSpineHref`
- `currentSpineIndex`
- `currentDisplayedPage`
- `currentDisplayedTotal`
- `currentCFI`
- `currentPercentage`

Only current-slot relocation may update this canonical state.

Non-current slot relocation should be logged, but must not update `ReaderViewModel` or `PageController`.

Acceptance:

- Logs distinguish `currentSlotRelocated` from `prewarmSlotRelocated`.
- Reader progress never changes from a background slot.
- `ReaderViewModel.handleRelocated` is called only for the visible current slot.

### Phase 4 - Replace Blind Adjacent Nudges With Explicit Slot Sync

Stop using blind recycled-slot commands:

- `prevSlot.prevPage()`
- `nextSlot.nextPage()`

Those commands are wrong because each slot may be on a stale page.

Instead, sync slots explicitly:

1. Current slot displays canonical CFI.
2. Previous slot displays canonical CFI, then performs exactly one `prevPage()`.
3. Next slot displays canonical CFI, then performs exactly one `nextPage()`.
4. Wait for each adjacent slot to report its resulting location.
5. Record slot target:
   - previous slot target CFI
   - current slot target CFI
   - next slot target CFI

Add JS helper:

```js
window.displayAndStep = async function(target, direction) {
  await rendition.display(target);
  if (direction === 'next') await rendition.next();
  if (direction === 'prev') await rendition.prev();
  return await readCurrentLocation('displayAndStep');
}
```

Expose typed Swift wrappers:

- `displayCurrent(_ cfi: String)`
- `displayAdjacent(baseCFI: String, direction: .previous/.next)`

Acceptance:

- After current location is intro page 1/10:
  - previous slot is public-domain page 1/1
  - current slot is intro page 1/10
  - next slot is intro page 2/10
- After turning forward:
  - current slot becomes intro page 2/10
  - next slot becomes intro page 3/10
  - previous slot becomes intro page 1/10

### Phase 5 - Rebuild PageCurl Rotation Around Confirmed Targets

After explicit sync works:

1. User swipes forward.
2. `UIPageViewController` shows `nextSlot`.
3. On completed transition:
   - set `poolCurrent = nextSlot`
   - wire callbacks
   - promote next slot's confirmed target to canonical current location
   - resync the recycled slot to the new next page
4. User swipes backward similarly.

Do not call `nextPage()` on the visible slot during the UIKit transition. The visible slot should already contain the target page before the curl starts.

Acceptance:

- Page curl visually reveals the next page that was already pre-rendered.
- Transition completion only updates bookkeeping and resyncs recycled slot.
- No user action causes both a UIKit slot transition and a JS `nextPage()` on a different slot.

### Phase 6 - Generate Or Load Locations For Percentage

The current CFI path is working, but percentage remains `0`.

Implementation:

1. Before display, try to load `Book.locationsCache` into JS.
2. If no cache exists, after first paint call `book.locations.generate(1024)` in a background JS task.
3. Send `locationsSnapshot` to Swift after generation.
4. After locations become available, recompute current percentage from current CFI.
5. Persist generated locations through `ReaderViewModel.handleLocationsSnapshot`.

Acceptance:

- `relocated` includes non-zero percentage after moving beyond the opening pages.
- Scrubber position moves as pages advance.
- Location generation does not block first paint.

### Phase 7 - Improve Initial Reading Target

Current selection chooses `public-domain.xhtml`, which is readable but not useful.

Update initial target priority:

1. If navigation/TOC has entries, choose the first TOC href that maps to a linear spine item with meaningful text.
2. Otherwise choose first linear spine item with:
   - at least 1500 characters, or
   - at least 250 words, or
   - title/href matching chapter/letter/introduction/preface.
3. Avoid likely boilerplate href/idref:
   - cover
   - titlepage
   - copyright
   - public-domain
   - dedication
   - epigraph

Acceptance:

- `Frankenstein.epub` opens at a meaningful reading section, likely introduction or letter 1 depending TOC.
- User does not land on a short legal/front-matter page unless restoring a saved CFI there.

### Phase 8 - Reduce Appearance Command Noise

The log shows appearance commands repeated across slots and after each slot load.

Implementation:

1. Store current appearance once in PageCurl controller.
2. Apply it once when a slot reaches `bookReady`.
3. Do not broadcast duplicate appearance commands while slots are mid-load.
4. Keep a short slot-level log: `appearanceApplied token=X`.

Acceptance:

- Each slot gets one appearance batch per load token.
- Page turns do not trigger repeated font/theme command storms.

### Phase 9 - Verify Phase 2c Against Master Plan

Run these checks before updating the master plan:

1. Open `Frankenstein.epub`.
2. Confirm meaningful text appears.
3. Tap/turn forward 12 times.
4. Confirm displayed page advances within the long chapter, not just between two spine items.
5. Turn backward 5 times.
6. Confirm previous pages are correct.
7. Confirm `relocated` updates CFI and percentage.
8. Confirm TOC jump works.
9. Confirm scrubber/go-to-location jumps to approximate percentage.
10. Confirm footnote sheet behavior.
11. Run Xcode build:

```sh
xcodebuild -project EpubReader.xcodeproj -scheme EpubReader -destination 'generic/platform=iOS Simulator' -derivedDataPath /tmp/EpubReaderDerivedData CODE_SIGNING_ALLOWED=NO build
```

## Immediate Implementation Order

1. Disable competing SwiftUI direct page-turn gestures or route them through typed controller methods.
2. Add single-slot paging debug mode and verify intro pages 1 -> 2 -> 3.
3. Track canonical current location only from visible slot relocation.
4. Add JS `displayAndStep(target, direction)` helper.
5. Sync prev/current/next slots to explicit targets.
6. Rebuild `rotateForward` / `rotateBackward` around confirmed slot targets.
7. Add locations cache/generation so percentages move.
8. Improve initial target selection to avoid public-domain/front matter.
9. Reduce appearance command duplication.
10. Rebuild and repeat manual smoke gate.
