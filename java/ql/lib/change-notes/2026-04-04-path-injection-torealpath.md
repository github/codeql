---
category: minorAnalysis
---
* The `java/path-injection` and `java/zipslip` queries now recognize `Path.toRealPath()` as a path normalization sanitizer, consistent with the existing treatment of `Path.normalize()` and `File.getCanonicalPath()`. This reduces false positives for code that uses the NIO.2 API for path canonicalization.
