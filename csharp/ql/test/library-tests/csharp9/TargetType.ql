import csharp

query predicate conditional(ConditionalExpr expr, string t, string t1, string t2) {
  expr.getType().toStringWithTypes() = t and
  expr.getThen().getType().toStringWithTypes() = t1 and
  expr.getElse().getType().toStringWithTypes() = t2
}
