import javascript

query predicate test_TypeAssertions(TypeAssertion expr, Expr res0, TypeExpr res1) {
  res0 = expr.getExpression() and res1 = expr.getTypeAnnotation()
}
