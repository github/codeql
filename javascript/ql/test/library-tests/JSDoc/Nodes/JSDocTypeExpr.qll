import semmle.javascript.JSDoc

query predicate test_JSDocTypeExpr(JSDocTypeExpr jsdte, JSDocTypeExprParent res0, int res1) {
  res0 = jsdte.getParent() and res1 = jsdte.getIndex()
}
