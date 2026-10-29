import javascript

query predicate test_IntersectionTypeExpr(IntersectionTypeExpr type, int n, int res0, TypeExpr res1) {
  res0 = type.getNumElementType() and res1 = type.getElementType(n)
}
