import javascript

query predicate test_RouteHandlerExpr_getAsSubRouter(
  Express::RouteHandlerExpr expr, Express::RouterDefinition res
) {
  res = expr.getAsSubRouter()
}
