import ruby

query predicate loops(Loop l, string lClass, Expr body, string bodyClass) {
  l.getBody() = body and lClass = l.getAPrimaryQlClass() and bodyClass = body.getAPrimaryQlClass()
}

query predicate conditionalLoops(
  ConditionalLoop l, string lClass, Expr cond, Expr body, string bodyClass
) {
  l.getBody() = body and
  lClass = l.getAPrimaryQlClass() and
  bodyClass = body.getAPrimaryQlClass() and
  cond = l.getCondition()
}

query predicate forExprs(ForExpr f, LhsExpr p, StmtSequence body, int i, Stmt bodyChild) {
  p = f.getPattern() and
  body = f.getBody() and
  bodyChild = body.getStmt(i)
}

query predicate forExprsTuplePatterns(ForExpr f, DestructuredLhsExpr tp, int i, Expr cp) {
  tp = f.getPattern() and
  cp = tp.getElement(i)
}

query predicate whileExprs(WhileExpr e, Expr cond, StmtSequence body, int i, Stmt bodyChild) {
  cond = e.getCondition() and
  body = e.getBody() and
  bodyChild = body.getStmt(i)
}

query predicate whileModifierExprs(WhileModifierExpr e, Expr cond, Expr body) {
  cond = e.getCondition() and
  body = e.getBody()
}

query predicate untilExprs(UntilExpr e, Expr cond, StmtSequence body, int i, Stmt bodyChild) {
  cond = e.getCondition() and
  body = e.getBody() and
  bodyChild = body.getStmt(i)
}

query predicate untilModifierExprs(UntilModifierExpr e, Expr cond, Expr body) {
  cond = e.getCondition() and
  body = e.getBody()
}
