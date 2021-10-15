import semmle.javascript.JSDoc

query predicate test_JSDocAppliedTypeExpr(
  JSDocAppliedTypeExpr jsdate, JSDocTypeExpr res0, int idx, JSDocTypeExpr res1
) {
  res0 = jsdate.getHead() and res1 = jsdate.getArgument(idx)
}
