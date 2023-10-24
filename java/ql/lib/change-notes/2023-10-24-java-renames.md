---
category: minorAnalysis
---
* Java classes `MethodAccess`, `LValue` and `RValue` were renamed to `MethodCall`, `VarWrite` and `VarRead` respectively, along with related predicates and class names. The old names remain usable for the time being but are deprecated and should be replaced.
* New class `NewClassExpr` was added to represent specifically an explicit `new ClassName(...)` invocation, in contrast to `ClassInstanceExpr` which also includes expressions that implicitly instantiate classes, such as defining a lambda or taking a method reference.
