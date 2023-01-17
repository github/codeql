import csharp

query predicate interpolatedstrings(InterpolatedStringExpr se, Expr e) {
  se.getFile().getStem() = "Strings" and
  (e = se.getAText() or e = se.getAnInsert())
}
