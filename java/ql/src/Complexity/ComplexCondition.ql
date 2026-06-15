/**
 * @name Complex condition
 * @description Very complex conditions are difficult to read and may include defects.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/complex-condition
 * @tags testability
 *       readability
 */

import java

predicate nontrivialLogicalOperator(BinaryExpr e) {
  e instanceof LogicExpr and
  (
    not e.getParent().(Expr).getKind() = e.getKind() or
    e.isParenthesized()
  )
}

Expr getSimpleParent(Expr e) {
  result = e.getParent() and
  not result instanceof MethodCall
}

from Expr e
where
  not e.getParent() instanceof Expr and
  strictcount(BinaryExpr op | getSimpleParent*(op) = e and nontrivialLogicalOperator(op)) > 5
select e, "Complex condition: too many logical operations in this expression."
