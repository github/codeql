import javascript

query predicate test_RouteHandlerExpr_getNextMiddleware(
  Express::RouteHandlerExpr expr, Express::RouteHandlerExpr res
) {
  res = expr.getNextMiddleware()
}
