---
category: minorAnalysis
---
* The `BufferAccess` library (`semmle.code.cpp.security.BufferAccess`) no longer matches buffer accesses inside unevaluated contexts (such as inside `sizeof` or `decltype` expressions). As a result, queries using this library may see fewer false positives.