import ruby

query predicate conditionalExprs(
  ConditionalExpr e, string pClass, Expr cond, Expr branch, boolean branchCond
) {
  pClass = e.getAPrimaryQlClass() and
  cond = e.getCondition() and
  branch = e.getBranch(branchCond)
}

query predicate ifOrElsifExprs(
  IfOrElsifExpr e, string pClass, Expr cond, ExprSequence thenExpr, string elseStr
) {
  pClass = e.getAPrimaryQlClass() and
  cond = e.getCondition() and
  thenExpr = e.getThen() and
  if exists(e.getElse()) then elseStr = e.getElse().toString() else elseStr = "(none)"
}

query predicate unlessExprs(
  UnlessExpr e, string pClass, Expr cond, ExprSequence thenExpr, string elseStr
) {
  pClass = e.getAPrimaryQlClass() and
  cond = e.getCondition() and
  thenExpr = e.getThen() and
  if exists(e.getElse()) then elseStr = e.getElse().toString() else elseStr = "(none)"
}

query predicate ifModifierExprs(IfModifierExpr e, string pClass, Expr cond, Expr expr) {
  pClass = e.getAPrimaryQlClass() and
  cond = e.getCondition() and
  expr = e.getExpr()
}

query predicate unlessModifierExprs(UnlessModifierExpr e, string pClass, Expr cond, Expr expr) {
  pClass = e.getAPrimaryQlClass() and
  cond = e.getCondition() and
  expr = e.getExpr()
}

query predicate ternaryIfExprs(
  TernaryIfExpr e, string pClass, Expr cond, Expr thenExpr, Expr elseExpr
) {
  pClass = e.getAPrimaryQlClass() and
  cond = e.getCondition() and
  thenExpr = e.getThen() and
  elseExpr = e.getElse()
}
