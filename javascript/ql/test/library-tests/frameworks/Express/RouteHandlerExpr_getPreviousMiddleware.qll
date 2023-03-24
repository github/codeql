import javascript

query predicate test_RouteHandlerExpr_getPreviousMiddleware(
  Express::RouteHandlerNode expr, Express::RouteHandlerNode res
) {
  res = expr.getPreviousMiddleware()
}
