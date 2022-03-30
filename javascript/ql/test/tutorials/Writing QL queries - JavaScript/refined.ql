import javascript

from Expr e
where
  e.isPure() and
  e.getParent() instanceof ExprStmt and
  not e.getParent() instanceof Directive // new check
select e, "This expression has no effect."
