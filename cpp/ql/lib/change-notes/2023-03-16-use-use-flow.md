---
category: majorAnalysis
---
* A new C/C++ dataflow library (`semmle.code.cpp.dataflow.new.DataFlow`) has been added.
  The new library behaves much more like the dataflow library of other CodeQL supported
  languages by following use-use dataflow paths instead of def-use dataflow paths.
  The new library also better supports dataflow through indirections, and new predicates
  such as `Node::asIndirectExpr` have been added to facilitate working with indirections.

  The `semmle.code.cpp.ir.dataflow.DataFlow` library is now identical to the new
  `semmle.code.cpp.dataflow.new.DataFlow` library.
