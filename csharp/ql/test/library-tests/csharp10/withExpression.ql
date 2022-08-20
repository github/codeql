import csharp

query predicate withExpressions(WithExpr with, string type, Expr expr, ObjectInitializer init) {
  type = with.getType().toStringWithTypes() and
  expr = with.getExpr() and
  init = with.getInitializer()
}
