/** Provides a taint-tracking configuration to reason about improper validation of local user-provided size used for array construction. */

import java
private import semmle.code.java.security.internal.ArraySizing
private import semmle.code.java.dataflow.FlowSources

/**
 * A taint-tracking configuration to reason about improper validation of local user-provided size used for array construction.
 */
deprecated module ImproperValidationOfArrayConstructionLocalConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) {
    any(CheckableArrayAccess caa).canThrowOutOfBoundsDueToEmptyArray(sink.asExpr(), _)
  }
}

/**
 * DEPRECATED: Use `ImproperValidationOfArrayConstructionFlow` instead and configure threat model sources to include `local`.
 *
 * Taint-tracking flow for improper validation of local user-provided size used for array construction.
 */
deprecated module ImproperValidationOfArrayConstructionLocalFlow =
  TaintTracking::Global<ImproperValidationOfArrayConstructionLocalConfig>;
