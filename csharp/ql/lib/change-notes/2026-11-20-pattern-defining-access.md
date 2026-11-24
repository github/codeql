---
category: fix
---
* The C# extractor now records defining accesses for local variables declared in patterns. These accesses are available through `LocalVariableDeclExpr.getAccess()` and are classified as writes.