import javascript

from Expr e
where
  e.isPure() and
  e.getParent() instanceof ExprStmt
select e, "This expression has no effect."
