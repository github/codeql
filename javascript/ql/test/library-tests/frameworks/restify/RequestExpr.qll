import javascript

query predicate test_RequestExpr(Restify::RequestExpr e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
