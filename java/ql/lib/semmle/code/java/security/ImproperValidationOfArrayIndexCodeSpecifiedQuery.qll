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
}

/**
 * Dataflow flow for improper validation of code-specified array index.
 */
module BoundedFlowSourceFlow = DataFlow::Global<BoundedFlowSourceConfig>;
