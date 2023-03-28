import csharp

query predicate interpolatedstrings(InterpolatedStringExpr se, Expr e) {
  se.getFile().getStem() = "Strings" and
  (e = se.getAText() or e = se.getAnInsert())
}

query predicate stringliterals(StringLiteral s, string qlclass, string type) {
  s.getFile().getStem() = "Strings" and
  s.getEnclosingCallable().getName() = ["M2", "M3"] and
  qlclass = s.getAPrimaryQlClass() and
  type = s.getType().toString()
}
