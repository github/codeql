import javascript

query predicate test_IsTypeExpr(IsTypeExpr type, VarTypeAccess res0, TypeExpr res1) {
  res0 = type.getParameterName() and res1 = type.getPredicateType()
}

query predicate test_PredicateTypeExpr(PredicateTypeExpr type, VarTypeAccess res0) {
  res0 = type.getParameterName()
}

query predicate test_hasAssertsKeyword(PredicateTypeExpr type) { type.hasAssertsKeyword() }
