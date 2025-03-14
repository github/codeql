---
category: minorAnalysis
---
* Added a path injection sanitizer for calls to `java.lang.String.matches`, `java.lang.String.replace`, and `java.lang.String.replaceAll` that make sure '/', '\', '..' are not in the path.
