---
category: minorAnalysis
---
* The `java/tainted-arithmetic` query no longer flags arithmetic expressions that are used directly as an operand of a comparison in `if`-condition bounds-checking patterns. For example, `if (off + len > array.length)` is now recognized as a bounds check rather than a potentially vulnerable computation, reducing false positives.
