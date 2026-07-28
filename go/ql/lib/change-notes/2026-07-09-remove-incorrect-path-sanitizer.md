---
category: minorAnalysis
---
* The function `Rel` in `path/filepath` was incorrectly considered a sanitizer for `go/path-injection` and `go/zipslip`. This has now been fixed, which may lead to more results for those queries.
