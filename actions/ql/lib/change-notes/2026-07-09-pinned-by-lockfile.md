---
category: minorAnalysis
---
* Added a new extensible predicate `pinnedByLockfileDataModel(workflow_path, nwo, ref)`, which records `uses:` references that are pinned by a repository's Actions lockfile (`.github/workflows/actions.lock`). The CodeQL Actions extractor generates this data at database-creation time into a database-local model pack (`codeql/actions-lockfile-pins`); it has no effect unless that pack is supplied to analysis (for example via `--model-packs`), so behaviour is unchanged for repositories without a lockfile or analyses that do not opt in.
