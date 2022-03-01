/**
 * @name Useless Test
 * @description A boolean condition that is guaranteed to never be evaluated should be deleted.
 * @kind problem
 * @problem.severity warning
 * @id cpp/uselesstest
 * @tags reliability
 *       readability
 */

import cpp
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

predicate sameExpr(Expr e1, Expr e2) { globalValueNumber(e1).getAnExpr() = e2 }

Element nearestParent(Expr e) {
  if
    e.getParent().(Expr).getConversion*() instanceof ParenthesisExpr or
    e.getParent() instanceof IfStmt or
    e.getParent() instanceof WhileStmt
  then result = e.getParent()
  else result = nearestParent(e.getParent())
}

from LogicalAndExpr b, EQExpr eq, NEExpr ne
where
  (
    b.getAChild*() = eq and
    b.getAChild*() = ne and
    eq.getParent() instanceof LogicalAndExpr and
    ne.getParent() instanceof LogicalAndExpr
  ) and
  (
    eq.getLeftOperand() instanceof VariableAccess and ne.getLeftOperand() instanceof VariableAccess
    or
    eq.getLeftOperand() instanceof PointerDereferenceExpr and
    ne.getLeftOperand() instanceof PointerDereferenceExpr
  ) and
  eq.getRightOperand() instanceof Literal and
  ne.getRightOperand() instanceof Literal and
  eq.getLeftOperand().getFullyConverted().getUnspecifiedType() =
    ne.getLeftOperand().getFullyConverted().getUnspecifiedType() and
  nearestParent(eq) = nearestParent(ne) and
  sameExpr(eq.getLeftOperand(), ne.getLeftOperand())
select ne, "Useless Test"
