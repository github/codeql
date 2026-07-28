---
category: minorAnalysis
---
* `java.io.File.getName()` is no longer treated as a complete sanitizer for `java/path-injection`, since it does not remove a `..` path component (for example `new File("..").getName()` returns `".."`). It is now only recognized as a sanitizer when combined with a subsequent check for `..` components, which may result in new alerts.
