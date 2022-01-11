import csharp

query predicate inserts(InterpolatedStringExpr expr, Expr e) { expr.getAnInsert() = e }

query predicate texts(InterpolatedStringExpr expr, StringLiteral literal) {
  expr.getAText() = literal
}
