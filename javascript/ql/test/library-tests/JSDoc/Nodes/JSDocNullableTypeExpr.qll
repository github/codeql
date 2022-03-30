import semmle.javascript.JSDoc

query predicate test_JSDocNullableTypeExpr(
  JSDocNullableTypeExpr jsdnte, JSDocTypeExpr res, string fixity
) {
  (if jsdnte.isPrefix() then fixity = "prefix" else fixity = "postfix") and
  res = jsdnte.getTypeExpr()
}
