import javascript

query predicate test_ParenthesizedTypeExpr(ParenthesizedTypeExpr type, TypeExpr res0, TypeExpr res1) {
  res0 = type.getElementType() and res1 = type.stripParens()
}
