## 0.7.2

### New Features

* Added an AST-based interface (`semmle.code.cpp.rangeanalysis.new.RangeAnalysis`) for the relative range analysis library.
* A new predicate `BarrierGuard::getAnIndirectBarrierNode` has been added to the new dataflow library (`semmle.code.cpp.dataflow.new.DataFlow`) to mark indirect expressions as barrier nodes using the `BarrierGuard` API.

### Major Analysis Improvements

* In the intermediate representation, handling of control flow after non-returning calls has been improved. This should remove false positives in queries that use the intermedite representation or libraries based on it, including the new data flow library.

### Minor Analysis Improvements

* The `StdNamespace` class now also includes all inline namespaces that are children of `std` namespace.
* The new dataflow (`semmle.code.cpp.dataflow.new.DataFlow`) and taint-tracking libraries (`semmle.code.cpp.dataflow.new.TaintTracking`) now support tracking flow through static local variables.
