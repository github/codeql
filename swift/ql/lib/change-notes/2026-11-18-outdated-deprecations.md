---
category: breaking
---
* Removed the deprecated `getImmediateBaseType`, `getBaseType`, and `getBaseTypeDecl` predicates on type declarations, `hasVarDecl` on named patterns, and `immediatelyControls` and `controls` on basic blocks. Use `getImmediateInheritedType`, `getInheritedType`, `getABaseTypeDecl`, `getVarDecl`, and `edgeDominates`, respectively, instead.
