---
category: minorAnalysis
---

* `PathSanitizer.qll` has been promoted from experimental to the main query pack. This sanitizer was originally [submitted as part of an experimental query by @luchua-bc](https://github.com/github/codeql/pull/7286).
* The queries `java/path-injection`, `java/path-injection-local` and `java/zipslip` now use the sanitizers provided by `PathSanitizer.qll`.