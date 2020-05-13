/**
 * @name User-controlled bypass of condition
 * @description A check that compares two user-controlled inputs with each other can be bypassed
 *              by a malicious user.
 * @id go/user-controlled-bypass
 * @kind problem
 * @problem.severity warning
 * @tags external/cwe/cwe-840
 */

import go

/**
 * A taint-tracking configuration for reasoning about conditional bypass.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ConditionalBypass" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof UntrustedFlowSource
    or
    source = any(Field f | f.hasQualifiedName("net/http", "Request", "Host")).getARead()
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(ComparisonExpr c | c.getAnOperand() = sink.asExpr())
  }
}

from
  Configuration config, DataFlow::PathNode lhsSource, DataFlow::PathNode lhs,
  DataFlow::PathNode rhsSource, DataFlow::PathNode rhs, ComparisonExpr c
where
  config.hasFlowPath(rhsSource, rhs) and
  rhs.getNode().asExpr() = c.getRightOperand() and
  config.hasFlowPath(lhsSource, lhs) and
  lhs.getNode().asExpr() = c.getLeftOperand()
select c,
  "This comparison compares user-controlled values from $@ and $@, and hence can be bypassed.",
  lhsSource, "here", rhsSource, "here"
