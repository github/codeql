import javascript

query predicate test_RouteExpr(Express::RouteExpr e, Express::RouterDefinition res) {
  res = e.getRouter()
}
