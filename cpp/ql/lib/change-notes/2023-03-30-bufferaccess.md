---
category: feature
---
* Added overridable predicates `getSizeExpr` and `getSizeMult` to the `BufferAccess` class (`semmle.code.cpp.security.BufferAccess.qll`). This makes it possible to model a larger class of buffer reads and writes using the library.