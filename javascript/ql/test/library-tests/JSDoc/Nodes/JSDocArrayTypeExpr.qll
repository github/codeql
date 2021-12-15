import semmle.javascript.JSDoc

query predicate test_JSDocArrayTypeExpr(JSDocArrayTypeExpr jsdate, int idx, JSDocTypeExpr res) {
  res = jsdate.getElementType(idx)
}
