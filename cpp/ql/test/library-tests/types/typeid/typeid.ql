import cpp

from TypeidOperator to, string exprLoc, string expr
where
  if exists(to.getExpr())
  then (
    exprLoc = to.getExpr().getLocation().toString() and
    expr = to.getExpr().toString()
  ) else (
    expr = "" and
    exprLoc = ""
  )
select to, to.getResultType(), exprLoc, expr
