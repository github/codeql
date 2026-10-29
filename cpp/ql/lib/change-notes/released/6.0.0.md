## 6.0.0

### Breaking Changes

* The "Guards" libraries (`semmle.code.cpp.controlflow.Guards` and `semmle.code.cpp.controlflow.IRGuards`) have been totally rewritten to recognize many more guards. The API remains unchanged, but the `GuardCondition` class now extends `Element` instead of `Expr`.

### New Features

* C/C++ `build-mode: none` support is now generally available.
