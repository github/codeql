import javascript

query predicate test_GenericTypeExpr(
  GenericTypeExpr type, TypeAccess res0, int n, int res1, TypeExpr res2
) {
  res0 = type.getTypeAccess() and
  res1 = type.getNumTypeArgument() and
  res2 = type.getTypeArgument(n)
}
