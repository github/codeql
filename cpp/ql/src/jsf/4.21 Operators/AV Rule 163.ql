/**
 * @name AV Rule 163
 * @description Unsigned arithmetic shall not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-163
 * @problem.severity recommendation
 * @tags correctness
 *       external/jsf
 */

import cpp

predicate excluded(Expr e) {
  // Don't bother with literals - signed/unsigned is less meaningful there
  e instanceof Literal
}

predicate isUnsignedOperand(Expr e) {
  e.getUnderlyingType().(IntegralType).isUnsigned() and
  not excluded(e)
}

from BinaryOperation op
where
  op instanceof BinaryArithmeticOperation and
  isUnsignedOperand(op.getChild(0)) and
  isUnsignedOperand(op.getChild(1))
select op, "AV Rule 163: unsigned arithmetic shall not be used"
