---
category: minorAnalysis
---
* Added member predicates `StructTag.hasOwnFieldWithTag` and `Field.getTag`, which enable CodeQL queries to examine struct field tags.
* Added member predicate `InterfaceType.hasPrivateMethodWithQualifiedName`, which enables CodeQL queries to distinguish interfaces with matching non-exported method names that are declared in different packages, and are therefore incompatible.
