import javascript

query predicate test_MappedTypeExpr(
  MappedTypeExpr type, TypeParameter res0, Identifier res1, TypeExpr res2, TypeExpr res3
) {
  res0 = type.getTypeParameter() and
  res1 = type.getTypeParameter().getIdentifier() and
  res2 = type.getTypeParameter().getBound() and
  res3 = type.getElementType()
}
