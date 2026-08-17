---
category: minorAnalysis
---
* The query `java/field-masks-super-field` no longer reports compiler-generated fields, which removes false positives for some Kotlin sealed class hierarchies with `open val` constructor parameters.
