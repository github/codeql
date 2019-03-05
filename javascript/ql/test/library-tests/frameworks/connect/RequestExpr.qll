import javascript

query predicate test_RequestExpr(Connect::RequestExpr e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
