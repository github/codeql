import javascript

query predicate test_TypeofTypeExpr(TypeofTypeExpr type, VarTypeAccess res) {
  res = type.getExpressionName()
}
