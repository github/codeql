import semmle.javascript.JSDoc

query predicate test_JSDocNonNullableTypeExpr(
  JSDocNonNullableTypeExpr jsdnte, JSDocTypeExpr res, string fixity
) {
  (if jsdnte.isPrefix() then fixity = "prefix" else fixity = "postfix") and
  res = jsdnte.getTypeExpr()
}
