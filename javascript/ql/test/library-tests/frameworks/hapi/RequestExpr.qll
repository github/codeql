import javascript

query predicate test_RequestExpr(Hapi::RequestExpr e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
