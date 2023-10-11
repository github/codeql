---
category: majorAnalysis
---

* The predicates `getABaseType`, `getABaseTypeDecl`, `getADerivedType` and `getADerivedTypeDecl` on `Type` and `TypeDecl` now behave more usefully and consistently. They now explore through type aliases used in base class declarations, and include protocols added in extensions.

To examine base class declarations at a low level without these enhancements, use `TypeDecl.getInheritedType`.

`Type.getABaseType` (only) previously resolved a type alias it was called directly on. This behaviour no longer exists. To find any base type of a type that could be an alias, the construct `Type.getUnderlyingType().getABaseType*()` is recommended.
