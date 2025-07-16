---
category: minorAnalysis
---
* Remove model`CreateTemp` function, from the `os` package, as a path-injection sink due to proper sanitization by Go. Add check for `os.PathSeparator` in sanitizers for path-injection query.