import javascript

query predicate test_TupleTypeExpr(TupleTypeExpr type, int n, int res0, TypeExpr res1) {
  res0 = type.getNumElementType() and res1 = type.getElementType(n)
}

query predicate test_TupleTypeElementName(TupleTypeExpr type, int n, Identifier name) {
  name = type.getElementName(n)
}
