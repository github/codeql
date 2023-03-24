import javascript

query predicate test_RouteHandlerExpr_getAMatchingAncestor(
  Express::RouteHandlerNode expr, Express::RouteHandlerNode res
) {
  res = expr.getAMatchingAncestor()
}
