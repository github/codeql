import semmle.javascript.JSDoc

query predicate test_JSDocRestParameterTypeExpr(
  JSDocRestParameterTypeExpr jsdopte, JSDocTypeExpr res
) {
  res = jsdopte.getUnderlyingType()
}
