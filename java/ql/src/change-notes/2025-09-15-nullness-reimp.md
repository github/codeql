---
category: majorAnalysis
---
* The implementation of `java/dereferenced-value-may-be-null` has been completely replaced with a new general control-flow reachability library. This improves precision by reducing false positives. However, since the entire calculation has been reworked, there can be small corner cases where precision regressions might occur and new false positives may occur, but these cases should be rare.
