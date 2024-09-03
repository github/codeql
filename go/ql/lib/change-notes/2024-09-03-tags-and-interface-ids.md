---
category: minorAnalysis
---
* Added methods `StructTag.hasOwnFieldWithTag` and `Field.getTag`, which enable CodeQL queries to examine struct field tags.
* Added method `InterfaceType.getMethodTypeById`, which enables CodeQL queries to distinguish interfaces with matching non-exported method names that are declared in different packages, and are therefore incompatible.
