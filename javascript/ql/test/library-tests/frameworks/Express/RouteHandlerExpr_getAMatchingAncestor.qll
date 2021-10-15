import javascript

query predicate test_RouteHandlerExpr_getAMatchingAncestor(
  Express::RouteHandlerExpr expr, Express::RouteHandlerExpr res
) {
  res = expr.getAMatchingAncestor()
}
