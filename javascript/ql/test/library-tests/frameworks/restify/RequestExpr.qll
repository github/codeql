import javascript

query predicate test_RequestExpr(Restify::RequestExpr e, https::RouteHandler res) {
  res = e.getRouteHandler()
}
