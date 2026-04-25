## Audit Date: 2026-04-25

### Fixed in this session
* **Book Metadata Editing (BookDetailView):** Metadata edits were being saved directly on the UI-bound managed object context, violating the master plan invariant that Core Data writes must execute on a background context.
  * **Fix applied:** Reworked `saveChanges()` to resolve the selected `Book` in a dedicated background context and persist title/author updates there, with rollback + structured logging on failure.
* **Core Data CloudKit Compatibility (xcdatamodel):** The data model was marked `usedWithCloudKit="false"`, which diverged from the architecture contract using `NSPersistentCloudKitContainer` for sync.
  * **Fix applied:** Updated the model descriptor to `usedWithCloudKit="true"` to align model metadata with CloudKit-backed persistence.

### Pending / Unfixed Mismatches
* **Book Soft-Delete Schema Naming (Core Data Model vs Plan):** Master plan defines `Book.isDeleted`, while the live model and code paths currently use `Book.softDeleted`.
  * **Why it wasn't fixed:** Renaming a persisted Core Data attribute safely requires a versioned model migration and coordinated updates across fetch predicates/import paths; this is a high-risk migration not safe for partial in-session edits.
  * **Recommended Next Steps:** Add a new model version with a lightweight/custom migration strategy (`softDeleted` → `isDeleted`), then update predicates/importers/tests in one controlled release.
* **CFI Fallback Storage Contract (ReadingProgress):** Master plan requires CFI persistence to include `spineHref`, `characterOffset`, and `contextSnippet`, but current `ReadingProgress` persists only `cfi` + `percentage` (+ metadata fields).
  * **Why it wasn't fixed:** Requires schema expansion plus end-to-end bridge/persistence wiring (JS payload, Swift bridge handlers, persistence upserts, and restore logic) to avoid regressions.
  * **Recommended Next Steps:** Introduce new Core Data attributes and update `EPUBBridge` relocation payload handling + `PageController` save/restore flow in a dedicated migration task.
