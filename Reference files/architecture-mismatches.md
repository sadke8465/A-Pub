## Audit Date: 2026-04-25

### Fixed in this session
* **Book Soft-Delete Contract (Library/Core Data):** The live codebase filtered/deleted on `Book.softDeleted`, while the master plan contract requires `Book.isDeleted`.
  * **Fix applied:** Added `Book.isDeleted` to the Core Data model, switched library fetch filtering to `isDeleted == NO`, and updated delete/import seed paths to write `isDeleted` (while still mirroring `softDeleted` for compatibility during transition).
* **CFI Fallback Storage Contract (ReadingProgress):** `ReadingProgress` stored only `cfi` + `percentage`, missing required fallback fields from the master plan.
  * **Fix applied:** Extended `ReadingProgress` schema with `spineHref`, `characterOffset`, and `contextSnippet`; updated JS relocation payload to send these values; expanded `EPUBBridge` relocation handling and `PageController` persistence writes to store the fallback metadata with each progress upsert.

### Pending / Unfixed Mismatches
* **Soft-Delete Legacy Field Cleanup (Book.softDeleted):** `softDeleted` remains in the model and is still mirrored for backward compatibility.
  * **Why it wasn't fixed:** Removing a legacy persisted field safely requires a coordinated model-version migration strategy and rollout validation to prevent store incompatibility for existing installs.
  * **Recommended Next Steps:** Create a versioned Core Data migration plan that deprecates/removes `softDeleted` after validating all records are migrated and all predicates/writes use `isDeleted` only.
