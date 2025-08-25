import cpp

from Function f, string explicit, Expr e, string value
where
  (if f.isExplicit() then explicit = "explicit" else explicit = "") and
  e = f.getExplicitExpr() and
  if exists(e.getValue()) then value = e.getValue() else value = ""
select f, explicit, e, value
