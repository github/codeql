import javascript

query predicate test_OptionalTypeExpr(OptionalTypeExpr type, TypeExpr res) {
  res = type.getElementType()
}
