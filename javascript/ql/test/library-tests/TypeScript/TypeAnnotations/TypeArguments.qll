import javascript

query predicate test_TypeArguments(InvokeExpr invoke, int n, int res0, TypeExpr res1) {
  res0 = invoke.getNumTypeArgument() and res1 = invoke.getTypeArgument(n)
}
