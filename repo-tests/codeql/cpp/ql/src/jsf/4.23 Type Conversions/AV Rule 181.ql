/**
 * @name AV Rule 181
 * @description Redundant explicit casts will not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-181
 * @problem.severity warning
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

from Expr e, Conversion c
where
  e.fromSource() and
  c = e.getConversion() and
  not c instanceof ParenthesisExpr and
  not c.isCompilerGenerated() and
  c.getUnderlyingType() = e.getUnderlyingType()
select c.findRootCause(), "AV Rule 181: Redundant explicit casts will not be used."
