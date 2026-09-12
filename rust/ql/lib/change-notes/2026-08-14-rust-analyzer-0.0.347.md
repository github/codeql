---
category: minorAnalysis
---
* The Rust extractor has been upgraded to use `rust-analyzer` version 0.0.347. As a result, the AST exposed by the Rust libraries has changed: new `DerefPat`, `ImplRestriction`, `IncludeBytesExpr`, `MutRestriction`, `NotNull`, `PatternTypeRepr`, and `VisibilityInner` classes have been added; the `FormatArgsArgName` class has been removed in favour of `FormatArgsArg.getName()`, which now returns a `Name`; `Visibility.getPath()` has been moved onto the new `VisibilityInner` class, reachable via `Visibility.getVisibilityInner()`; and `attrs` have been added to the inline assembly nodes, `getMutRestriction()` to `StructField` and `TupleField`, and `getImplRestriction()` to `Trait`.
