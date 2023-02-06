## 0.3.0

### Deprecated APIs

* The `BarrierGuard` class has been deprecated. Such barriers and sanitizers can now instead be created using the new `BarrierGuard` parameterized module.

### Bug Fixes

* `UserType.getADeclarationEntry()` now yields all forward declarations when the user type is a `class`, `struct`, or `union`.
