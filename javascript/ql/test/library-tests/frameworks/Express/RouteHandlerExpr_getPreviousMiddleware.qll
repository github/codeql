import javascript

query predicate test_RouteHandlerExpr_getPreviousMiddleware(
  Express::RouteHandlerExpr expr, Express::RouteHandlerExpr res
) {
  res = expr.getPreviousMiddleware()
}
