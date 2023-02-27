---
category: minorAnalysis
---
* The query `go/incorrect-integer-conversion` now correctly recognises guards of the form `if val <= x` to protect a conversion `uintX(val)` when `x` is in the range `(math.MaxIntX, math.MaxUintX]`.
