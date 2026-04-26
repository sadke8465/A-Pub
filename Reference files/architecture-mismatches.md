## Audit Date: 2026-04-25

### Fixed in this session
* **EPUB description metadata dropped end-to-end (Core/EPUB + Core/Utilities + Library):** `EPUBBook` had no `description` field, `EPUBParser.parseMetadata` ignored `<dc:description>`, and `MetadataExtractor` always wrote an empty `bookDescription` — leaving `Book.bookDescription` permanently empty, hiding `BookDetailView`'s description section, and breaking the master-plan FTS5 contract (`book_fts(id, title, author, description)` per task 5.2).
  * **Fix applied:** Added `description: String` to `EPUBBook`, extended `EPUBParser`'s `ParsedMetadata` to capture `dc:description` from the OPF and propagate it into the constructed `EPUBBook`, and updated both `MetadataExtractor.extract` overloads to forward `book.description` as `bookDescription` so the value flows into Core Data on import.
* **Cover JPEG filename mis-keyed (Core/Utilities/CoverImageExtractor):** `destinationURL` derived the on-disk filename from a hash of `book.identifier` (or a title/author fallback) instead of the EPUB file `sha256` mandated by master-plan task 1.4 (`Application Support/covers/{sha256}.jpg`). This broke alignment with `Book.sha256` (the canonical dedupe key) and meant cover paths could not be recomputed from the persisted Book row.
  * **Fix applied:** Changed `CoverImageExtractor.extract` to require an explicit `sha256: String`, replaced `destinationURL(for:)` with `destinationURL(forSHA256:)` writing to `covers/{sha256}.jpg`, removed the now-unused identifier-hash code path (and the orphaned `CryptoKit` import), and updated `FileImporter` to thread the same `sha256` it already computes for dedupe and Book persistence into the cover extractor call.

### Pending / Unfixed Mismatches
* None at this time.
