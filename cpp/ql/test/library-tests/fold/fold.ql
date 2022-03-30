import cpp

from FoldExpr fe, Expr pack, string init
where
  pack = fe.getPackExpr() and
  if exists(fe.getInitExpr()) then init = fe.getInitExpr().toString() else init = "<no init>"
select fe, fe.getOperatorString(), pack, init
