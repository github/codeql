import javascript

query predicate test_RouteHandlerExpr_getNextMiddleware(
  Express::RouteHandlerNode expr, Express::RouteHandlerNode res
) {
  res = expr.getNextMiddleware()
}
