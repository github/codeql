---
category: minorAnalysis
---
* Fixed taint propagation for attribute assignment. In the assignment `x.foo = tainted` we no longer treat the entire object `x` as tainted, just because the attribute `foo` contains tainted data. This leads to slightly fewer false positives.
