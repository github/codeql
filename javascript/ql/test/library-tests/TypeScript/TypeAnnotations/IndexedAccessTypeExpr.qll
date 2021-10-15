import javascript

query predicate test_IndexedAccessTypeExpr(IndexedAccessTypeExpr type, TypeExpr res0, TypeExpr res1) {
  res0 = type.getObjectType() and res1 = type.getIndexType()
}
