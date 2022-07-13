## 0.1.0

### Breaking Changes

* The recently added flow-state versions of `isBarrierIn`, `isBarrierOut`, `isSanitizerIn`, and `isSanitizerOut` in the data flow and taint tracking libraries have been removed.

### New Features

* A new library `semmle.code.cpp.security.PrivateData` has been added. The new library heuristically detects variables and functions dealing with sensitive private data, such as e-mail addresses and credit card numbers.

### Minor Analysis Improvements

* The `semmle.code.cpp.security.SensitiveExprs` library has been enhanced with some additional rules for detecting credentials.
