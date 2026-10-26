## 5.3.0

### Deprecated APIs

* The `UnknownDefaultLocation`, `UnknownExprLocation`, and `UnknownStmtLocation` classes have been deprecated. Use `UnknownLocation` instead.

### New Features

* Added a `isFinalValueOfParameter` predicate to `DataFlow::Node` which holds when a dataflow node represents the final value of an output parameter of a function.

### Minor Analysis Improvements

* The `FunctionWithWrappers` library (`semmle.code.cpp.security.FunctionWithWrappers`) no longer considers calls through function pointers as wrapper functions.
* The analysis of C/C++ code targeting 64-bit Arm platforms has been improved. This includes support for the Arm-specific builtin functions, support for the `arm_neon.h` header and Neon vector types, and support for the `fp8` scalar type. The `arm_sve.h` header and scalable vectors are only partially supported at this point.
* Added support for `__fp16 _Complex` and `__bf16 _Complex` types
* Added `sql-injection` sink models for the Oracle Call Interface (OCI) database library functions `OCIStmtPrepare` and `OCIStmtPrepare2`.
