/**
 * @name Useless Test
 * @description Find any useless test of kind a==8 && a!=7
 * @kind problem
 * @problem.severity warning
 * @id cpp/uselesstest
 * @tags reliability
 *       readability
 */

import cpp

predicate sameStmt(Expr e1, Expr e2) {
  e1.getNumChild() = e2.getNumChild() and
  e1.toString() = e2.toString() and
  (
    e1.getNumChild() = 0
    or
    forall(int i | i in [0 .. e1.getNumChild() - 1] | sameStmt(e1.getChild(i), e2.getChild(i)))
  )
}

Element nearestParent(Expr e) {
  if
    e.getParent().(Expr).getFullyConverted() instanceof ParenthesisExpr or
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
    eq.getChild(0) instanceof VariableAccess and ne.getChild(0) instanceof VariableAccess
    or
    eq.getChild(0) instanceof PointerDereferenceExpr and
    ne.getChild(0) instanceof PointerDereferenceExpr
  ) and
  eq.getChild(1) instanceof Literal and
  ne.getChild(1) instanceof Literal and
  nearestParent(eq) = nearestParent(ne) and
  sameStmt(eq.getChild(0), ne.getChild(0))
select "Useless test", ne