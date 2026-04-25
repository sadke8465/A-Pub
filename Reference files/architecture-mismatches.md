## Audit Date: 2026-04-25

### Fixed in this session
* **Library Persistence Write Path (LibraryViewModel):** Library mutating operations (`createShelf`, `addBook(_:to:)`, `markBookFinished(_:)`, `softDelete(_:)`) were writing directly on the main/view context, violating the master plan invariant that all Core Data writes run on background contexts.
  * **Fix applied:** Refactored these mutations to run through a shared background-write pipeline using `PersistenceController.backgroundContext()`, persisted changes from background contexts, and refreshed shelf UI state on successful shelf creation.

### Pending / Unfixed Mismatches
* **None identified at critical severity in current scope after this audit.**
  * **Why it wasn't fixed:** N/A.
  * **Recommended Next Steps:** Re-run an architecture audit after implementing additional reader-state persistence and sync tasks.
