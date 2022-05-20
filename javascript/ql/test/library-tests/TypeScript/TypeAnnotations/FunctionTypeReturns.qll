import javascript

query predicate test_FunctionTypeReturns(FunctionTypeExpr type, TypeExpr res) {
  res = type.getReturnTypeAnnotation()
}
