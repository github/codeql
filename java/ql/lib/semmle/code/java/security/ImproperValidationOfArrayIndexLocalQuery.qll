/** Provides a taint-tracking configuration to reason about improper validation of local user-provided array index. */

import java
private import semmle.code.java.security.internal.ArraySizing
private import semmle.code.java.dataflow.FlowSources

/**
 * A taint-tracking configuration to reason about improper validation of local user-provided array index.
 */
deprecated module ImproperValidationOfArrayIndexLocalConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) {
    any(CheckableArrayAccess caa).canThrowOutOfBounds(sink.asExpr())
  }

  predicate isBarrier(DataFlow::Node node) { node.getType() instanceof BooleanType }

  predicate isBarrierIn(DataFlow::Node node) { isSource(node) }
}

/**
 * DEPRECATED: Use `ImproperValidationOfArrayIndexFlow` instead and configure threat model sources to include `local`.
 *
 * Taint-tracking flow for improper validation of local user-provided array index.
 */
deprecated module ImproperValidationOfArrayIndexLocalFlow =
  TaintTracking::Global<ImproperValidationOfArrayIndexLocalConfig>;
