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
 *       experimental
 *       security
 */

import go
import SensitiveConditionBypass

from
  ControlFlow::ConditionGuardNode guard, DataFlow::Node sensitiveSink,
  SensitiveExpr::Classification classification, DataFlow::Node source, DataFlow::Node operand,
  ComparisonExpr comp
where
  // there should be a flow between source and the operand sink
  Flow::flow(source, operand) and
  // both the operand should belong to the same comparison expression
  operand.asExpr() = comp.getAnOperand() and
  // get the ConditionGuardNode corresponding to the comparison expr.
  guard.getCondition() = comp and
  // the sink `sensitiveSink` should be sensitive,
  isSensitive(sensitiveSink, classification) and
  // the guard should control the sink
  guard.dominates(sensitiveSink.getBasicBlock())
select comp, "This sensitive comparision check can potentially be bypassed."
