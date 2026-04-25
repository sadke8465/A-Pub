## Audit Date: 2026-04-25

### Fixed in this session
* **Book Soft-Delete Contract (Library/Core Data):** The live codebase filtered/deleted on `Book.softDeleted`, while the master plan contract requires `Book.isDeleted`.
  * **Fix applied:** Added `Book.isDeleted` to the Core Data model, switched library fetch filtering to `isDeleted == NO`, updated delete/import seed paths to write `isDeleted`, and removed legacy `softDeleted` writes from runtime codepaths.
* **CFI Fallback Storage Contract (ReadingProgress):** `ReadingProgress` stored only `cfi` + `percentage`, missing required fallback fields from the master plan.
  * **Fix applied:** Extended `ReadingProgress` schema with `spineHref`, `characterOffset`, and `contextSnippet`; updated JS relocation payload to send these values; expanded `EPUBBridge` relocation handling and `PageController` persistence writes to store the fallback metadata with each progress upsert.

### Pending / Unfixed Mismatches
* None at this time.
