/**
 * @name AV Rule 212
 * @description Underflow or overflow functioning shall not be depended on
 *              in any special way.
 * @kind problem
 * @id cpp/jsf/av-rule-212
 * @problem.severity error
 * @tags correctness
 *       portability
 *       external/jsf
 */

import cpp

/*
 * This query checks for the use of the "a + b < a" idiom.
 */

predicate isNonNegative(Expr e) {
  e.getUnderlyingType().(IntegralType).isUnsigned() or
  e.getValue().toInt() >= 0
}

predicate sameExpr(Expr e, Expr f) {
  e.(VariableAccess).getTarget() = f.(VariableAccess).getTarget()
  // adding the following disjunct OOMs on non-trivial databases
  //or e.getValue() = f.getValue()
}

class UnreliableOverflowTest extends LTExpr {
  UnreliableOverflowTest() {
    exists(AddExpr l, Expr a, Expr b, Expr r |
      l = super.getLeftOperand() and
      a = l.getLeftOperand() and
      b = l.getRightOperand() and
      r = super.getRightOperand() and
      (
        sameExpr(a, r) and isNonNegative(b)
        or
        sameExpr(b, r) and isNonNegative(a)
      )
    )
  }
}

from UnreliableOverflowTest t
select t, "AV Rule 212: Underflow or overflow functioning shall not be depended on."
