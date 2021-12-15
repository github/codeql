import semmle.javascript.JSDoc

query predicate test_JSDocOptionalParameterTypeExpr(
  JSDocOptionalParameterTypeExpr jsdopte, JSDocTypeExpr res
) {
  res = jsdopte.getUnderlyingType()
}
