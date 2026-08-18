---
category: minorAnalysis
---
* The Rust extractor has been upgraded to use `rust-analyzer` version 0.0.328. As a result, the AST exposed by the Rust libraries has changed: the `TraitAlias` class has been removed, `cfg` attributes are now modeled by the new `CfgMeta`, `CfgAtom`, `CfgComposite`, `CfgPredicate`, and `CfgAttrMeta` classes, and the `Meta` class has been refined into the `KeyValueMeta`, `PathMeta`, `TokenTreeMeta`, and `UnsafeMeta` subclasses. New `TryBlockModifier` and `FormatArgsArgName` classes have also been added.
