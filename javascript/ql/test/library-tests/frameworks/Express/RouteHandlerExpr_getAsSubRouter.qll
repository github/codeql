import javascript

query predicate test_RouteHandlerExpr_getAsSubRouter(
  Express::RouteHandlerNode expr, Express::RouterDefinition res
) {
  res = expr.getAsSubRouter()
}
