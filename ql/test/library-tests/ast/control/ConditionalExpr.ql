import ruby

query predicate conditionalExprs(
  ConditionalExpr e, string pClass, Expr cond, Expr branch, boolean branchCond
) {
  pClass = e.getAPrimaryQlClass() and
  cond = e.getCondition() and
  branch = e.getBranch(branchCond)
}

query predicate ifExprs(
  IfExpr e, string pClass, Expr cond, StmtSequence thenExpr, string elseStr, boolean isElsif
) {
  pClass = e.getAPrimaryQlClass() and
  cond = e.getCondition() and
  thenExpr = e.getThen() and
  (if exists(e.getElse()) then elseStr = e.getElse().toString() else elseStr = "(none)") and
  if e.isElsif() then isElsif = true else isElsif = false
}

query predicate unlessExprs(
  UnlessExpr e, string pClass, Expr cond, StmtSequence thenExpr, string elseStr
) {
  pClass = e.getAPrimaryQlClass() and
  cond = e.getCondition() and
  thenExpr = e.getThen() and
  if exists(e.getElse()) then elseStr = e.getElse().toString() else elseStr = "(none)"
}

query predicate ifModifierExprs(IfModifierExpr e, string pClass, Expr cond, Expr expr) {
  pClass = e.getAPrimaryQlClass() and
  cond = e.getCondition() and
  expr = e.getBody()
}

query predicate unlessModifierExprs(UnlessModifierExpr e, string pClass, Expr cond, Expr expr) {
  pClass = e.getAPrimaryQlClass() and
  cond = e.getCondition() and
  expr = e.getBody()
}

query predicate ternaryIfExprs(
  TernaryIfExpr e, string pClass, Expr cond, Expr thenExpr, Expr elseExpr
) {
  pClass = e.getAPrimaryQlClass() and
  cond = e.getCondition() and
  thenExpr = e.getThen() and
  elseExpr = e.getElse()
}
