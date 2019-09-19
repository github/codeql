import cpp

from ArrayExpr ae, string meth, Expr expr
where
  meth = "getArrayBase" and expr = ae.getArrayBase()
  or
  meth = "getArrayOffset" and expr = ae.getArrayOffset()
select meth, expr
