import javascript

query predicate test_TypeAccessHelpers(TypeAccess type, int res0, int n, TypeExpr res1) {
  type.hasTypeArguments() and res0 = type.getNumTypeArgument() and res1 = type.getTypeArgument(n)
}
