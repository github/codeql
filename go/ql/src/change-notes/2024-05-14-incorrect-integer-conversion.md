---
category: minorAnalysis
---
* The query `go/incorrect-integer-conversion` has now been restricted to only use flow through value-preserving steps. This reduces false positives, especially around type switches.
