---
category: feature
---
* Added a new library `semmle.code.java.security.Sanitizers` which contains a new sanitizer class `SimpleTypeSanitizer`, which represents nodes which cannot realistically carry taint for most queries (e.g. primitives, their boxed equivalents, and numeric types).
* Converted definitions of `isBarrier` and sanitizer classes to use `SimpleTypeSanitizer` instead of checking if `node.getType()` is `PrimitiveType` or `BoxedType`.
