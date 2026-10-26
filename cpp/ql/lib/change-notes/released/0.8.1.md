## 0.8.1

### Deprecated APIs

* The library `semmle.code.cpp.dataflow.DataFlow` has been deprecated. Please use `semmle.code.cpp.dataflow.new.DataFlow` instead.

### New Features

* The `DataFlow::StateConfigSig` signature module has gained default implementations for `isBarrier/2` and `isAdditionalFlowStep/4`. 
  Hence it is no longer needed to provide `none()` implementations of these predicates if they are not needed.

### Minor Analysis Improvements

* Data flow configurations can now include a predicate `neverSkip(Node node)`
  in order to ensure inclusion of certain nodes in the path explanations. The
  predicate defaults to the end-points of the additional flow steps provided in
  the configuration, which means that such steps now always are visible by
  default in path explanations.
* The `IRGuards` library has improved handling of pointer addition and subtraction operations.
