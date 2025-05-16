/**
 * @name User-controlled bypass of condition
 * @description A check that compares two user-controlled inputs with each other can be bypassed
 *              by a malicious user.
 * @id go/user-controlled-bypass
 * @kind problem
 * @problem.severity warning
 * @tags external/cwe/cwe-840
 *       security
 *       experimental
 */

import go

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof ActiveThreatModelSource
    or
    source = any(Field f | f.hasQualifiedName("net/http", "Request", "Host")).getARead()
  }

  predicate isSink(DataFlow::Node sink) {
    exists(ComparisonExpr c | c.getAnOperand() = sink.asExpr())
  }

  predicate observeDiffInformedIncrementalMode() {
    // TODO(diff-informed): Manually verify if config can be diff-informed.
    // ql/src/experimental/CWE-840/ConditionalBypass.ql:38: Column 1 does not select a source or sink originating from the flow call on line 34
    // ql/src/experimental/CWE-840/ConditionalBypass.ql:38: Column 1 does not select a source or sink originating from the flow call on line 36
    // ql/src/experimental/CWE-840/ConditionalBypass.ql:38: Column 3 does not select a source or sink originating from the flow call on line 34
    // ql/src/experimental/CWE-840/ConditionalBypass.ql:39: Column 5 does not select a source or sink originating from the flow call on line 36
    none()
  }
}

/** Tracks taint flow for reasoning about conditional bypass. */
module Flow = TaintTracking::Global<Config>;

from
  DataFlow::Node lhsSource, DataFlow::Node lhs, DataFlow::Node rhsSource, DataFlow::Node rhs,
  ComparisonExpr c
where
  Flow::flow(rhsSource, rhs) and
  rhs.asExpr() = c.getRightOperand() and
  Flow::flow(lhsSource, lhs) and
  lhs.asExpr() = c.getLeftOperand()
select c, "This comparison of a $@ with another $@ can be bypassed by a malicious user.", lhsSource,
  "user-controlled value", rhsSource, "user-controlled value"
