/**
 * @name Order by const
 * @description Ordering by a constant has no effect, and is an indication is a misplaced order by clause.
 * @kind problem
 * @problem.severity warning
 * @id ql/order-by-const
 * @tags correctness
 *       maintainability
 * @precision medium
 */

import ql

Expr getAnOrderBy(AstNode parent, string kind) {
  result = parent.(FullAggregate).getOrderBy(_) and
  kind = parent.(FullAggregate).getKind() + " aggregate"
  or
  result = parent.(Select).getOrderBy(_) and kind = "select"
  or
  result = parent.(ExprAggregate).getOrderBy(_) and
  kind = parent.(ExprAggregate).getKind() + " aggregate"
}

from Expr orderBy, AstNode parent, string kind
where
  orderBy = getAnOrderBy(parent, kind) and
  orderBy instanceof Literal
select orderBy, "Ordering $@ by a constant.", parent, kind
