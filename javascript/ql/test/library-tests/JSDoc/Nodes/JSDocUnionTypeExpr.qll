import semmle.javascript.JSDoc

query predicate test_JSDocUnionTypeExpr(JSDocUnionTypeExpr jsdute, JSDocTypeExpr res) {
  res = jsdute.getAnAlternative()
}
