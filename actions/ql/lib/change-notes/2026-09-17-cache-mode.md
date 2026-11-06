---
category: feature
---
* Added `Workflow.getCacheMode()` and `Job.getCacheMode()` to read explicitly declared cache modes. The `hasDefaultBranchCacheWriteAccess` predicate now accounts for these modes, job overrides, and explicit caller limits in reusable workflows.
* `runsOnDefaultBranch` now includes unfiltered branch pushes and `pull_request` `closed` events that may refer to a merge into the default branch, while excluding tag-only pushes.
