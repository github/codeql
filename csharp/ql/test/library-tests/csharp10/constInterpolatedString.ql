import csharp

private predicate inSpecificSource(Expr expr) {
  expr.getFile().getBaseName() = "ConstInterpolatedString.cs"
}

query predicate inserts(InterpolatedStringExpr expr, Expr e) {
  expr.getAnInsert() = e and inSpecificSource(expr)
}

query predicate texts(InterpolatedStringExpr expr, StringLiteral literal) {
  expr.getAText() = literal and inSpecificSource(expr)
}
