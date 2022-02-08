## 0.0.7

## 0.0.6

### Major Analysis Improvements

* Data flow now propagates taint from remote source `Parameter` types to read steps of their fields (e.g. `tainted.publicField` or `tainted.getField()`). This also applies to their subtypes and the types of their fields, recursively.

## 0.0.5

### Bug Fixes

* `CharacterLiteral`'s `getCodePointValue` predicate now returns the correct value for UTF-16 surrogates.
* The `RangeAnalysis` module now properly handles comparisons with Unicode surrogate character literals.

## 0.0.4

### Bug Fixes

* `CharacterLiteral`'s `getCodePointValue` predicate now returns the correct value for UTF-16 surrogates.
* The `RangeAnalysis` module and the `java/constant-comparison` queries no longer raise false alerts regarding comparisons with Unicode surrogate character literals.
* The predicate `Method.overrides(Method)` was accidentally transitive. This has been fixed. This fix also affects `Method.overridesOrInstantiates(Method)` and `Method.getASourceOverriddenMethod()`.
