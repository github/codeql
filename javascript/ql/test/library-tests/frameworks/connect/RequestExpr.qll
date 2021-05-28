import javascript

query predicate test_RequestExpr(Connect::RequestExpr e, https::RouteHandler res) {
  res = e.getRouteHandler()
}
