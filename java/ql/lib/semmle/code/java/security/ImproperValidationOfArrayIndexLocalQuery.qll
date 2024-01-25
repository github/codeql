/** Provides a taint-tracking configuration to reason about improper validation of local user-provided array index. */

import java
private import semmle.code.java.security.internal.ArraySizing
private import semmle.code.java.dataflow.FlowSources

/**
 * A taint-tracking configuration to reason about improper validation of local user-provided array index.
 */
module ImproperValidationOfArrayIndexLocalConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) {
    any(CheckableArrayAccess caa).canThrowOutOfBounds(sink.asExpr())
  }

  predicate isBarrier(DataFlow::Node node) { node.getType() instanceof BooleanType }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

/**
 * Taint-tracking flow for improper validation of local user-provided array index.
 */
module ImproperValidationOfArrayIndexLocalFlow =
  TaintTracking::Global<ImproperValidationOfArrayIndexLocalConfig>;
