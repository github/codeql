---
category: minorAnalysis
---
* When a guard such as `isSafe(x)` is defined, we now also automatically handle comparisons to boolean literals such as `isSafe(x) is True`, `isSafe(x) == True`, `isSafe(x) is not False`, and `isSafe(x) != False`.
