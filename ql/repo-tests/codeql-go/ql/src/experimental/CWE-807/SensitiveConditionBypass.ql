/**
 * @name User-controlled bypassing of sensitive action
 * @description This query tests for user-controlled bypassing
 *  of sensitive actions.
 * @id go/sensitive-condition-bypass
 * @kind problem
 * @problem.severity warning
 * @tags external/cwe/cwe-807
 *       external/cwe/cwe-247
 *       external/cwe/cwe-350
 */

import go
import SensitiveConditionBypass

from
  ControlFlow::ConditionGuardNode guard, DataFlow::Node sensitiveSink,
  SensitiveExpr::Classification classification, Configuration config, DataFlow::PathNode source,
  DataFlow::PathNode operand, ComparisonExpr comp
where
  // there should be a flow between source and the operand sink
  config.hasFlowPath(source, operand) and
  // both the operand should belong to the same comparision expression
  operand.getNode().asExpr() = comp.getAnOperand() and
  // get the ConditionGuardNode corresponding to the comparision expr.
  guard.getCondition() = comp and
  // the sink `sensitiveSink` should be sensitive,
  isSensitive(sensitiveSink, classification) and
  // the guard should control the sink
  guard.dominates(sensitiveSink.getBasicBlock())
select comp, "This sensitive comparision check can potentially be bypassed."
