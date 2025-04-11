---
category: majorAnalysis
---
* The query `rb/uninitialized-local-variable` now only produces alerts when the variable is the receiver of a method call and should produce very few false positives. It also now comes with a help file.
