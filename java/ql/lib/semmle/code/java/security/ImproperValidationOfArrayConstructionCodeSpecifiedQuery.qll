/** Provides a dataflow configuration to reason about improper validation of code-specified size used for array construction. */

import java
private import semmle.code.java.security.internal.ArraySizing
private import semmle.code.java.dataflow.TaintTracking

/**
 * A dataflow configuration to reason about improper validation of code-specified size used for array construction.
 */
module BoundedFlowSourceConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof BoundedFlowSource and
    // There is not a fixed lower bound which is greater than zero.
    not source.(BoundedFlowSource).lowerBound() > 0
  }

  predicate isSink(DataFlow::Node sink) {
    any(CheckableArrayAccess caa).canThrowOutOfBoundsDueToEmptyArray(sink.asExpr(), _)
  }

  predicate observeDiffInformedIncrementalMode() {
    any() // TODO: Make sure that the location overrides match the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 27 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-129/ImproperValidationOfArrayConstructionCodeSpecified.ql@28:8:28:33), Column 5 does not select a source or sink originating from the flow call on line 27 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-129/ImproperValidationOfArrayConstructionCodeSpecified.ql@29:85:29:97)
  }
}

/**
 * Dataflow flow for improper validation of code-specified size used for array construction.
 */
module BoundedFlowSourceFlow = DataFlow::Global<BoundedFlowSourceConfig>;
