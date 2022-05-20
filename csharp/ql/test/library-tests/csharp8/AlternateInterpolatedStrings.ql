import csharp

query predicate inserts(InterpolatedStringExpr expr, int i, Expr insert) {
  insert = expr.getInsert(i)
}

query predicate text(InterpolatedStringExpr expr, int i, StringLiteral literal) {
  literal = expr.getText(i)
}
