import csharp

query predicate interpolatedstrings(InterpolatedStringExpr se, Expr e) {
  se.getFile().getStem() = "Strings" and
  (e = se.getAText() or e = se.getAnInsert())
}

query predicate stringliterals(StringLiteral s) {
  s.getFile().getStem() = "Strings" and s.getEnclosingCallable().getName() = "M2"
}
