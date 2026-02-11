## 5.2.0

### Deprecated APIs

* The `ThrowingFunction` class (`semmle.code.cpp.models.interfaces.Throwing`) has been deprecated. Please use the `AlwaysSehThrowingFunction` class instead.

### New Features

* Added a predicate `getAnAttribute` to `Namespace` to retrieve a namespace attribute.
* The Microsoft-specific `__leave` statement is now supported.
* A new class `LeaveStmt` extending `JumpStmt` was added to represent `__leave` statements.
* Added a predicate `hasParameterList` to `LambdaExpression` to capture whether a lambda has an explicitly specified parameter list.

### Bug Fixes

* `resolveTypedefs` now properly resolves typedefs for `ArrayType`s.
