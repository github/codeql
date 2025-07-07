/** Provides a taint-tracking configuration to reason about improper validation of user-provided size used for array construction. */

import java
private import semmle.code.java.security.internal.ArraySizing
private import semmle.code.java.dataflow.FlowSources

/**
 * A taint-tracking configuration to reason about improper validation of
 * user-provided size used for array construction.
 */
module ImproperValidationOfArrayConstructionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) {
    any(CheckableArrayAccess caa).canThrowOutOfBoundsDueToEmptyArray(sink.asExpr(), _)
  }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    exists(ArrayCreationExpr arrayCreation, CheckableArrayAccess arrayAccess |
      result = [arrayCreation, arrayAccess.getIndexExpr()].getLocation() and
      arrayAccess.canThrowOutOfBoundsDueToEmptyArray(sink.asExpr(), arrayCreation)
    )
  }
}

/**
 * Taint-tracking flow for improper validation of user-provided size used
 * for array construction.
 */
module ImproperValidationOfArrayConstructionFlow =
  TaintTracking::Global<ImproperValidationOfArrayConstructionConfig>;
