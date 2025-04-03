---
category: majorAnalysis
---
* The query `rb/uninitialized-local-variable` now only produces alerts when it can find local flow; this will produce vastly fewer alerts, eliminating most false positives.
