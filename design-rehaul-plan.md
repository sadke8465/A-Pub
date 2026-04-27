# Design Rehaul Plan

## Product Principles

1. The book is the master.
   - The reading experience belongs to the book, not the app chrome.
   - When the user wants to read, they should see the whole book and nothing else.
   - Controls appear only when summoned, then get out of the way.

2. Motion should feel physical.
   - Use spring-based animations that feel native, light, and responsive.
   - Motion should clarify state changes, preserve orientation, and reduce friction.
   - Avoid decorative animation that competes with reading.

## Reader Direction

The reader should default to a fully immersive state:

- No persistent top bar.
- No persistent bottom bar.
- No visible scrubber until controls are shown or the user is navigating.
- No decorative material layers over the page.
- Page turn gestures and tap zones remain invisible.

The book content should be the dominant and almost exclusive visual element.

## Reader Controls

Controls should be reachable with one intentional action:

- Tap the center of the page to reveal controls.
- Tap again, interact, or wait briefly to hide controls.
- Settings must be one tap away from the revealed state.
- Back, appearance, table of contents, and go-to-location are the core actions.
- Hide unfinished actions such as search or text-to-speech until they are functional.

Recommended visible control structure:

- A small floating back control near the leading safe area.
- A small floating action cluster near the trailing safe area.
- Chapter title and progress only while controls are visible.
- Scrubber only while controls are visible or actively dragging.

Controls should never feel like permanent furniture.

## Physics-Based Animation System

Use shared animation constants instead of scattered animation values.

Suggested baseline:

```swift
enum AppMotion {
    static let readerChrome = Animation.spring(response: 0.28, dampingFraction: 0.86)
    static let layout = Animation.spring(response: 0.34, dampingFraction: 0.9)
    static let quickSettle = Animation.spring(response: 0.22, dampingFraction: 0.88)
    static let interactive = Animation.interactiveSpring(response: 0.24, dampingFraction: 0.82)
}
```

Apply motion intentionally:

- Reader controls appear with opacity, scale, and slight vertical movement.
- Scrubber tracks direct manipulation immediately, then settles with spring motion.
- Library grid/list changes use a soft spring transition.
- Book detail presentation should feel native and stable.
- Appearance setting changes should update the book without disruptive transitions.

Respect Reduce Motion:

- Fall back to opacity-only transitions where appropriate.
- Keep native sheet presentation behavior.
- Avoid scale or movement animations for users who reduce motion.

## Appearance Settings

Settings should be easy to reach and fast to use:

- Open from the revealed reader controls in one tap.
- Use a native grouped settings sheet.
- Put the most-used controls first:
  - Theme
  - Font size
  - Font family
  - Margins
  - Line spacing
- Use `LabeledContent`, segmented controls, toggles, sliders, and steppers where they fit.
- Make "Save for this book" an explicit toolbar or menu action.
- Remove hidden long-press behavior for important actions.
- Apply changes live and preserve the current reading location.

## Library Direction

The library should be calm, professional, and secondary to reading:

- Covers are the primary objects.
- Metadata should be minimal: title, author, progress.
- Avoid heavy cards, decorative shelves, and random bright placeholder colors.
- Use responsive cover ratios rather than fixed heights.
- Use `ContentUnavailableView` for the empty library state.
- Opening a book should feel direct and immediate.

## View Architecture

Split large SwiftUI views into focused files:

- `ReaderChrome`
- `ReaderScrubber`
- `GoToLocationSheet`
- `FootnoteSheet`
- `ReaderTOCPanel`
- `BookCoverView`
- `BookProgressIndicator`
- `LibraryContentView`
- `LibraryEmptyState`
- `LibraryToolbar`

Keep layout and behavior separate:

- Move button actions into methods where they do more than call a simple closure.
- Avoid large private `some View` helpers when a dedicated `View` struct is clearer.
- Avoid `AnyView` in recursive TOC rows if a typed view can model the branch.
- Consolidate duplicate TOC implementations.

## Design Foundation

Create shared design constants:

- Spacing
- Corner radii
- Minimum tap sizes
- Cover aspect ratios
- Material usage
- Motion presets
- Toolbar control sizing

Use native SwiftUI styling:

- Prefer hierarchical foreground styles over manual opacity.
- Prefer `Label` for icon plus text.
- Prefer SwiftUI `Color` and asset colors over UIKit colors in SwiftUI views.
- Avoid `.caption2` for meaningful text.
- Enforce 44x44 minimum tap areas.

## Implementation Order

1. Add shared design and motion constants.
2. Extract reader chrome and scrubber from `ReaderView`.
3. Redesign reader controls as floating, auto-hiding UI.
4. Make appearance settings one tap away and rebuild them as native grouped settings.
5. Consolidate TOC and footnote sheets.
6. Add Reduce Motion handling.
7. Refine library grid, list, empty state, and cover presentation.
8. Add final Dynamic Type and accessibility pass.

## Success Criteria

- Opening a book presents only the book by default.
- Settings are reachable in one tap after revealing controls.
- Reader controls auto-hide reliably.
- Reader controls do not permanently occlude book content.
- Page turn, tap zones, table of contents, go-to-location, and appearance changes still work.
- Animations feel physical, restrained, and native.
- The library feels minimal and professional without competing with the reader.

