import ruby

query predicate conditionalExprsWithElse(
  ConditionalExpr e, Expr cond, Expr thenExpr, Expr elseExpr, string pClass
) {
  pClass = e.getAPrimaryQlClass() and
  cond = e.getCondition() and
  thenExpr = e.getThen() and
  elseExpr = e.getElse()
}

query predicate conditionalExprsWithoutElse(
  ConditionalExpr e, Expr cond, Expr thenExpr, string pClass
) {
  pClass = e.getAPrimaryQlClass() and
  cond = e.getCondition() and
  thenExpr = e.getThen() and
  not exists(e.getElse())
}

predicate helper(ConditionalExpr e, string pClass, Expr cond, Expr thenExpr, string elseStr) {
  pClass = e.getAPrimaryQlClass() and
  cond = e.getCondition() and
  thenExpr = e.getThen() and
  if exists(e.getElse()) then elseStr = e.getElse().toString() else elseStr = "(none)"
}

query predicate ifOrElsifExprs(
  IfOrElsifExpr e, string pClass, Expr cond, ThenExpr thenExpr, string elseStr
) {
  helper(e, pClass, cond, thenExpr, elseStr)
}

query predicate unlessExprs(
  UnlessExpr e, string pClass, Expr cond, ThenExpr thenExpr, string elseStr
) {
  helper(e, pClass, cond, thenExpr, elseStr)
}

query predicate ifModifierExprs(
  IfModifierExpr e, string pClass, Expr cond, Expr thenExpr, string elseStr
) {
  helper(e, pClass, cond, thenExpr, elseStr)
}

query predicate unlessModifierExprs(
  UnlessModifierExpr e, string pClass, Expr cond, Expr thenExpr, string elseStr
) {
  helper(e, pClass, cond, thenExpr, elseStr)
}

query predicate ternaryIfExprs(
  TernaryIfExpr e, string pClass, Expr cond, Expr thenExpr, Expr elseExpr
) {
  pClass = e.getAPrimaryQlClass() and
  cond = e.getCondition() and
  thenExpr = e.getThen() and
  elseExpr = e.getElse()
}
