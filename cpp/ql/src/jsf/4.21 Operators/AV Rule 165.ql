/**
 * @name Negation of unsigned value
 * @description The unary minus operator should not be applied to unsigned expressions - cast the expression to a signed type to avoid unexpected behavior.
 * @kind problem
 * @id cpp/jsf/av-rule-165
 * @problem.severity warning
 * @tags reliability
 */
import cpp

// see MISRA Rule 5-3-2

from UnaryMinusExpr ume
where ume.getOperand().getUnderlyingType().(IntegralType).isUnsigned()
      and not ume.getOperand() instanceof Literal
select ume, "The unary minus operator should not be applied to an unsigned expression."
