## 0.0.4

### Bug Fixes

* `CharacterLiteral`'s `getCodePointValue` predicate now returns the correct value for UTF-16 surrogates.
* The `RangeAnalysis` module and the `java/constant-comparison` queries no longer raise false alerts regarding comparisons with Unicode surrogate character literals.
* The predicate `Method.overrides(Method)` was accidentally transitive. This has been fixed. This fix also affects `Method.overridesOrInstantiates(Method)` and `Method.getASourceOverriddenMethod()`.
