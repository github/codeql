---
category: minorAnalysis
---
* The `cs/linq/missed-*` queries no longer suggest rewrites that would capture `in`, `out`, or `ref` parameters in a lambda, fixing false-positive results for transformations that would not compile.
