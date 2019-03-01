import javascript

query predicate test_RestTypeExpr(RestTypeExpr rest, TypeExpr res0, TypeExpr res1) {
  res0 = rest.getArrayType() and res1 = rest.getElementType()
}
