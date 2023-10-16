## 0.1.1

No user-facing changes.

## 0.1.0

### Major Analysis Improvements

* Added support for type-based call edge pruning. This removes data flow call edges that are incompatible with the set of flow paths that reach it based on type information. This improves dispatch precision for constructs like lambdas, `Object.toString()` calls, and the visitor pattern. For now this is only enabled for Java and C#.

### Minor Analysis Improvements

* The `isBarrierIn` and `isBarrierOut` predicates in `DataFlow::StateConfigSig` now have overloaded variants that block a specific `FlowState`.

## 0.0.4

No user-facing changes.

## 0.0.3

### New Features

* The various inline flow test libraries have been consolidated as a shared library part in the dataflow qlpack.

### Minor Analysis Improvements

* The shared taint-tracking library is now part of the dataflow qlpack.

## 0.0.2

### Major Analysis Improvements

* Initial release. Adds a library to implement flow through captured variables that properly adheres to inter-procedural control flow.

## 0.0.1

### New Features

* The `StateConfigSig` signature now supports a unary `isSink` predicate that does not specify the `FlowState` for which the given node is a sink. Instead, any `FlowState` is considered a valid `FlowState` for such a sink.

### Minor Analysis Improvements

* Initial release. Moves the shared inter-procedural data-flow library into its own qlpack.
