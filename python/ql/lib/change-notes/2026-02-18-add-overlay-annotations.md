---
category: majorAnalysis
---

- The CodeQL Python libraries have been updated to be compatible with overlay evaluation. This should result in a significant speedup on analyses for which a base database already exists. Note that it may be necessary to add `overlay[local?] module;` to user-managed libraries that extend classes that are now marked as `overlay[local]`.
