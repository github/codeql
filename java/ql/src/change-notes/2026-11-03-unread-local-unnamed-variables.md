---
category: minorAnalysis
---
* The `java/local-variable-is-never-read` query no longer reports unnamed variables (`_`), for example in `case Foo _ ->` patterns, `for (var _ : items)` loops, and `var _ = ...;` declarations.
