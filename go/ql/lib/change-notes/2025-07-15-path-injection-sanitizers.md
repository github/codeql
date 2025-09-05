---
category: minorAnalysis
---
* The second argument of the `CreateTemp` function, from the `os` package, is no longer a path-injection sink due to proper sanitization by Go.
* The query "Uncontrolled data used in path expression" (`go/path-injection`) now detects sanitizing a path by adding `os.PathSeparator` or `\` to the beginning.