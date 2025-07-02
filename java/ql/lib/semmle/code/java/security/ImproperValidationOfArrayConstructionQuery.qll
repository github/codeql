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

  predicate observeDiffInformedIncrementalMode() {
    any() // TODO: Make sure that the location overrides match the query's select clause: Column 1 does not select a source or sink originating from the flow call on line 25 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-129/ImproperValidationOfArrayConstruction.ql@26:8:26:33), Column 5 does not select a source or sink originating from the flow call on line 25 (/Users/d10c/src/semmle-code/ql/java/ql/src/Security/CWE/CWE-129/ImproperValidationOfArrayConstruction.ql@27:87:27:99)
  }
}

/**
 * Taint-tracking flow for improper validation of user-provided size used
 * for array construction.
 */
module ImproperValidationOfArrayConstructionFlow =
  TaintTracking::Global<ImproperValidationOfArrayConstructionConfig>;
