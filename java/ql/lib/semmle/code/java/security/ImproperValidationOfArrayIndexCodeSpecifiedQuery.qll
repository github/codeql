/** Provides a dataflow configuration to reason about improper validation of code-specified array index. */

import java
private import semmle.code.java.security.internal.ArraySizing
private import semmle.code.java.security.internal.BoundingChecks
private import semmle.code.java.dataflow.DataFlow

/**
 * A dataflow configuration to reason about improper validation of code-specified array index.
 */
module BoundedFlowSourceConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof BoundedFlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(CheckableArrayAccess arrayAccess | arrayAccess.canThrowOutOfBounds(sink.asExpr()))
  }

  predicate observeDiffInformedIncrementalMode() {
    any() // TODO: Make sure that the location overrides match the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 26 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-129/ImproperValidationOfArrayIndexCodeSpecified.ql@48:8:48:33)
  }
}

/**
 * Dataflow flow for improper validation of code-specified array index.
 */
module BoundedFlowSourceFlow = DataFlow::Global<BoundedFlowSourceConfig>;
