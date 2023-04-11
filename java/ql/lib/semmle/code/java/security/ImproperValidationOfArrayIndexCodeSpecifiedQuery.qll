/** Provides a dataflow configuration to reason about improper validation of code-specified array index. */

import java
import semmle.code.java.security.internal.ArraySizing
import semmle.code.java.security.internal.BoundingChecks
import semmle.code.java.dataflow.TaintTracking

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
