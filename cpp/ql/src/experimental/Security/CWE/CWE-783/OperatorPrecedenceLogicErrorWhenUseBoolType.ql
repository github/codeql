/**
 * @name Operator Precedence Logic Error When Use Bool Type
 * @description --Finding places of confusing use of boolean type.
 *              --For example, a unary minus does not work before a boolean type and an increment always gives true.
 * @kind problem
 * @id cpp/operator-precedence-logic-error-when-use-bool-type
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-783
 *       external/cwe/cwe-480
 */

import cpp
import semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis

/** Holds, if it is an expression, a boolean increment. */
predicate incrementBoolType(Expr exp) {
  exp.(IncrementOperation).getOperand().getType() instanceof BoolType
}

/** Holds, if this is an expression, applies a minus to a boolean type. */
predicate revertSignBoolType(Expr exp) {
  exp.(AssignExpr).getRValue().(UnaryMinusExpr).getAnOperand().getType() instanceof BoolType and
  exp.(AssignExpr).getLValue().getType() instanceof BoolType
}

/** Holds, if this is an expression, uses comparison and assignment outside of execution precedence. */
predicate assignBoolType(Expr exp) {
  exists(ComparisonOperation co |
    exp.(AssignExpr).getRValue() = co and
    exp.isCondition() and
    not co.isParenthesised() and
    not exp.(AssignExpr).getLValue().getType() instanceof BoolType and
    co.getLeftOperand() instanceof FunctionCall and
    not co.getRightOperand().getType() instanceof BoolType and
    not co.getRightOperand().getValue() = "0" and
    not co.getRightOperand().getValue() = "1"
  )
}

from Expr exp
where
  incrementBoolType(exp) or
  revertSignBoolType(exp) or
  assignBoolType(exp)
select exp, "this expression needs attention"
