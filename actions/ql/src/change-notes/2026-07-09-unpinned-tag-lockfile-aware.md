---
category: minorAnalysis
---
* The `actions/unpinned-tag` query no longer reports `uses:` references that are recorded as pinned by a repository's Actions lockfile (`.github/workflows/actions.lock`) via the new `pinnedByLockfileDataModel` extensible predicate. This predicate is populated by the CodeQL Actions extractor and has no effect until that support ships.
