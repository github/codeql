---
category: minorAnalysis
---
* Added a new extensible predicate `pinnedByLockfileDataModel(workflow_path, nwo, ref)`, which records `uses:` references that are pinned by a repository's Actions lockfile (`.github/workflows/actions.lock`). It is intended to be populated by the CodeQL Actions extractor and is currently unpopulated, so it has no effect until that support ships.
