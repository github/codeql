## 0.3.3

### New Features

* Added a predicate `getValueConstant` to `AttributeArgument` that yields the argument value as an `Expr` when the value is a constant expression.
* A new class predicate `MustFlowConfiguration::allowInterproceduralFlow` has been added to the `semmle.code.cpp.ir.dataflow.MustFlow` library. The new predicate can be overridden to disable interprocedural flow.
* Added subclasses of `BuiltInOperations` for `__builtin_bit_cast`, `__builtin_shuffle`, `__has_unique_object_representations`, `__is_aggregate`, and `__is_assignable`.

### Major Analysis Improvements

* The IR dataflow library now includes flow through global variables. This enables new findings in many scenarios.
