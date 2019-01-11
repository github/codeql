import javascript

from ParExpr e, Expr inner
where
  inner = e.stripParens() and
  inner != e
select e, inner
