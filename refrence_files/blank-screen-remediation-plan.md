# Blank Screen / No Text Rendering — Remediation Plan

## Scope
This plan targets the current failure mode where the reader loads `reader.html` but page navigation and style commands fail with JavaScript exceptions such as:
- `TypeError: undefined is not an object (evaluating 'this.manager.next')`
- `TypeError: undefined is not an object (evaluating 'this.manager.prev')`
- `TypeError: undefined is not an object (evaluating 'this.manager.resize')`

The plan aligns with:
- `refrence_files/master-plan.md` (WKWebView bridge invariants, 3-webview pool limit, strict error surfacing).
- `refrence_files/epubjs-wkwebview-knowledge-base.md` (epub.js readiness lifecycle and manager assumptions).
- Existing page-curl architecture in `PageCurlViewController` + `reader.html`.

---

## 1) Problem framing from evidence

### 1.1 Likely primary failure
The exceptions are emitted from commands (`nextPage`, `prevPage`, appearance setters) that eventually invoke `rendition.next/prev/resize` while `rendition` exists but its internal manager is not ready or has become invalid.

This suggests a race between:
1) host page readiness (`reader.html` loaded),
2) `loadBook()` being dispatched,
3) `rendition.display()` + `book.ready` completion,
4) user gestures / style updates calling JS too early,
5) slot rotation prewarm calls (`nextPage/prevPage`) running against a not-fully-ready slot.

### 1.2 Secondary noise to de-prioritize
From the console sample:
- iOS Simulator file picker thumbnail warnings and icon symbol warnings are non-blocking.
- AutoLayout keyboard warnings are unrelated to epub.js rendering.
- Missing old hashed EPUB path is historical stale reference noise.

These should not be treated as root causes for blank rendering.

---

## 2) Root-cause hypothesis matrix

### H1 — Command-before-ready race (highest confidence)
- `PageCurlViewController` marks slot “ready” on `didFinish` for `reader.html`, not on JS `bookReady` event.
- Commands can be sent to slots after HTML load but before epub.js manager is fully initialized.

### H2 — Slot state divergence in 3-webview pool
- Rotating pool calls `prevPage()/nextPage()` on recycled slots as a prewarm action.
- If prewarm executes before slot-local book lifecycle completion, manager-dependent calls throw.

### H3 — Bridge callback mismatch / dropped readiness signal
- `onBookReady` is wired only for current slot; non-current slots may never have explicit “safe-to-command” gating despite receiving prewarm/style commands.

### H4 — Lifecycle invalidation after process pressure
- Repeated `WebProcess::updateFreezerStatus` may indicate lifecycle churn.
- If web content process reloads and JS global state resets, stale command dispatch can target a fresh page without initialized rendition.

---

## 3) Fix strategy (phased)

## Phase A — Add explicit slot lifecycle state machine (must-do first)

### A1. Introduce per-slot state enum
In `PageCurlViewController`, track each slot with states:
- `htmlLoaded`
- `bookLoading`
- `bookReady`
- `failed(error)`

Only `bookReady` slots may execute manager-dependent commands.

### A2. Add JS readiness handshake by slot
Extend JS -> Swift messaging so `bookReady` includes enough context to map to slot (slot index can stay Swift-side if callback is registered per bridge instance).

Set state transition:
- when `loadBook()` dispatched: `bookLoading`
- on `bookReady`: `bookReady`
- on `bookError`: `failed`

### A3. Gate all JS command dispatch
Wrap `callJS` entry points used for:
- `nextPage`, `prevPage`
- `setFontFamily`, `setFontSize`, `setLineSpacing`, `setMargin`, `setJustify`, `setHyphenation`
- any prewarm call during rotate

Behavior:
- if slot not `bookReady`, queue command FIFO.
- on transition to `bookReady`, flush queue in order.
- expire queued commands when slot enters `failed` or a new `loadBook` token starts.

## Phase B — Make load cycles tokenized and idempotent

### B1. Add per-slot `loadToken`
Every `loadBook` increments a token and tags pending operations.
Ignore stale `bookReady/bookError/relocated` events whose token != current token.

### B2. Debounce duplicate loads
If same `bookURL` already loading/ready on slot with same token context, skip redundant load dispatch.

### B3. Hard reset before re-load
Before new `loadBook`, clear queued commands and reset slot state to `bookLoading` so old manager references cannot leak into new lifecycle.

## Phase C — Harden `reader.html` runtime guards

### C1. Introduce `canNavigate()` and `canResize()` guards
Inside `reader.html`, centralize checks:
- `window.rendition` exists
- `window.rendition.manager` exists
- rendition not in transient destroyed state

When guard fails:
- do not throw
- post structured warning event `bridge.send('jsGuardBlocked', { command, reason })`

### C2. Wrap manager-dependent calls
`nextPage`, `prevPage`, and all resize/theme setters should:
1) run guard,
2) execute in `try/catch`,
3) report structured errors via `bookError/jsCommandError` instead of uncaught exception.

### C3. Ensure display completion before signaling ready
Keep `bookReady` emission strictly after:
- `renderTo` success,
- event handlers installed,
- `await rendition.display()`,
- `await book.ready`.

(Already mostly present; validate no alternate path emits ready too early.)

## Phase D — Improve Swift observability and user-visible recovery

### D1. Structured bridge telemetry
Extend `EPUBBridge.JavaScriptExecutionFailure` logging with:
- slot index
- slot lifecycle state
- load token
- command family (`navigation`, `appearance`, `load`)

### D2. ReaderViewModel state-driven fallback UX
If current slot enters `failed` or repeated `jsGuardBlocked` exceeds threshold:
- show non-blocking banner: “Reloading chapter…”
- trigger controlled reload (`loadBook` current slot only, then pool sync)
- preserve last known CFI.

### D3. Crash-free command policy
Never drop to silent failure:
- all blocked commands must either queue or emit explicit diagnostics.

## Phase E — File resolution and import-path integrity

### E1. Validate selected file accessibility window
On import, immediately verify read access and file existence for the chosen URL.

### E2. Remove stale hashed path assumptions
Do not persist/attempt old simulator temp path lookups unless revalidated.
Only load from currently registered `EPUBFileSchemeHandler` token URL.

### E3. Add explicit user-facing import error
If file is missing/inaccessible, fail fast with actionable message (not blank reader state).

---

## 4) Verification plan (acceptance criteria)

## Functional
1. Fresh import opens first chapter text within target time; no blank viewport.
2. During first 3 seconds post-load, repeated `next/prev` taps do not emit manager undefined exceptions.
3. Appearance changes (font family, spacing, margin, hyphenation, justify) before and after first relocation succeed without JS exceptions.
4. Page-curl forward/backward 20 turns keeps all slots healthy, no manager undefined exceptions.

## Diagnostics
5. Any blocked command logs one structured `jsGuardBlocked` event, not a crashy exception.
6. All JS failures include slot + token + command metadata.
7. No silent book load failures: any load error surfaces via `bookError` and a visible UI state.

## Regression / performance
8. 3-slot pool limit maintained.
9. No forced unwraps introduced.
10. No private WebKit API usage added.

---

## 5) Implementation checklist (ordered)

1. Add slot lifecycle + command queue + token model in `PageCurlViewController`.
2. Wire slot-specific ready/failure transitions from bridge callbacks.
3. Replace direct prewarm `nextPage/prevPage` calls with gated/queued dispatch helper.
4. Add JS guard helpers and structured warning events in `reader.html`.
5. Handle `jsGuardBlocked` event in `EPUBBridge` and forward to `ReaderViewModel` telemetry.
6. Add recovery UX in `ReaderView` / `ReaderViewModel` for slot failure.
7. Add missing-file import validation in importer/load path and explicit user message.
8. Run simulator stress matrix and collect logs.

---

## 6) Test matrix

- Books: tiny EPUB, medium novel, image-heavy EPUB, malformed EPUB.
- Devices: iPhone portrait, iPhone landscape, iPad split view.
- Flows:
  - import -> immediate rapid taps
  - import -> appearance adjustments before first turn
  - 20 forward curls + 20 backward curls
  - background/foreground while reading
  - memory pressure simulation if available

Pass condition: zero occurrences of `undefined is not an object (evaluating 'this.manager...')` and no blank text screen.

---

## 7) Rollout / risk control

- Ship behind temporary runtime flag `reader.strictSlotReadiness` default ON in debug, staged ON in release candidate.
- Keep enhanced logging for one beta cycle.
- If regressions appear, disable strict mode fallback to current behavior while retaining telemetry.

