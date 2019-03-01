import javascript

query predicate test_MethodDefinitions(
  MethodDefinition md, Expr res0, FunctionExpr res1, ClassDefinition res2
) {
  res0 = md.getNameExpr() and res1 = md.getBody() and res2 = md.getDeclaringClass()
}
