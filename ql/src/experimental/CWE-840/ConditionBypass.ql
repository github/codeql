/**
 * @name Comparision Expression Check Bypass
 * @description Comparing two user controlled inputs may
 * lead to an effective bypass of the comparison check.
 * @id go/condition-bypass
 * @kind problem
 * @problem.severity warning
 * @tags external/cwe/cwe-840
 */

import go

/**
 * A data-flow configuration for reasoning about Condition Bypass.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "Comparision Expression Check Bypass" }

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
select c, "This comparision is between user controlled operands derived from $@", lhsSource,
  " and $@", rhsSource, "hence may be bypassed."
