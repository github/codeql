/**
 * @name AV Rule 184
 * @description Floating point numbers shall not be converted to integers,
 *              unless such a conversion is a specified algorithmic
 *              requirement or is necessary for a hardware interface.
 * @kind problem
 * @id cpp/jsf/av-rule-184
 * @problem.severity warning
 * @tags correctness
 *       external/jsf
 */

import cpp

// extend to allow certain conversions
predicate necessaryFloatToIntConversion(Expr e) { none() }

predicate badConversion(Expr e) {
  e.fromSource() and
  e.getUnderlyingType() instanceof FloatingPointType and
  e.getActualType() instanceof IntegralType and
  not necessaryFloatToIntConversion(e)
}

from Expr e
where
  badConversion(e) and
  // Only include outermost matches; no need to be transitive
  // (should report an expr if a distant parent is a violation
  //  but the exprs in between are fine). Exclude brackets
  not badConversion(e.getParent()) and
  not e instanceof ParenthesisExpr
select e, "AV Rule 184: Floating point numbers shall not be converted to integers."
