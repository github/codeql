import semmle.javascript.JSDoc

query predicate test_JSDocFunctionTypeExpr(
  JSDocFunctionTypeExpr jsdfte, string ret, string recv, int idx, JSDocTypeExpr res, string isctor
) {
  (
    if exists(jsdfte.getResultType())
    then ret = jsdfte.getResultType().toString()
    else ret = "(none)"
  ) and
  (
    if exists(jsdfte.getReceiverType())
    then recv = jsdfte.getReceiverType().toString()
    else recv = "(none)"
  ) and
  (if jsdfte.isConstructorType() then isctor = "yes" else isctor = "no") and
  res = jsdfte.getParameterType(idx)
}
