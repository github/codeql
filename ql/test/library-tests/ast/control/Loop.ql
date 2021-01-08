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

query predicate forExprs(ForExpr f, Pattern p, ExprSequence body, int i, Expr bodyChild) {
  p = f.getPattern() and
  body = f.getBody() and
  bodyChild = body.getExpr(i)
}

query predicate forExprsTuplePatterns(ForExpr f, TuplePattern tp, int i, Pattern cp) {
  tp = f.getPattern() and
  cp = tp.getElement(i)
}

query predicate whileExprs(WhileExpr e, Expr cond, ExprSequence body, int i, Expr bodyChild) {
  cond = e.getCondition() and
  body = e.getBody() and
  bodyChild = body.getExpr(i)
}

query predicate whileModifierExprs(WhileModifierExpr e, Expr cond, Expr body) {
  cond = e.getCondition() and
  body = e.getBody()
}

query predicate untilExprs(UntilExpr e, Expr cond, ExprSequence body, int i, Expr bodyChild) {
  cond = e.getCondition() and
  body = e.getBody() and
  bodyChild = body.getExpr(i)
}

query predicate untilModifierExprs(UntilModifierExpr e, Expr cond, Expr body) {
  cond = e.getCondition() and
  body = e.getBody()
}
