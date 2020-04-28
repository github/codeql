/**
 * @name Comparision Expression Check Bypass
 * @description This query tests for user-controlled bypassing
 *  of a comparision expression i.e. instances where both the
 *  lhs and rhs of a comparision are user controlled.
 * @id go/condition-bypass
 * @kind problem
 * @problem.severity medium
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
    exists(string fieldName |
      source.(DataFlow::FieldReadNode).getField().hasQualifiedName("net/http", "Request", fieldName)
    |
      fieldName = "Host"
    )
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
select c, "This comparision is between user controlled operands and "
+ "hence may be bypassed."
