import javascript

query predicate test_RequestExpr(HTTP::RequestExpr e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
