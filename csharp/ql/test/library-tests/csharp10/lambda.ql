import csharp

private predicate getLambda(
  LocalVariableDeclAndInitExpr e, string type, LocalVariable v, LambdaExpr lexp
) {
  lexp = e.getRValue() and
  v = e.getTargetVariable() and
  type = e.getType().toStringWithTypes()
}

query predicate lambdaDeclaration(string type, LocalVariable v, LambdaExpr lexp) {
  getLambda(_, type, v, lexp)
}

query predicate lambdaDeclarationNatural(string type, LocalVariable v, LambdaExpr lexp) {
  exists(LocalVariableDeclAndInitExpr e | getLambda(e, type, v, lexp) and e.isImplicitlyTyped())
}

query predicate lambdaDeclarationExplicitReturnType(
  string type, string explicit, string actual, LocalVariable v, LambdaExpr lexp
) {
  getLambda(_, type, v, lexp) and
  explicit = lexp.getExplicitReturnType().toStringWithTypes() and
  actual = lexp.getReturnType().toStringWithTypes()
}
