import javascript

query predicate test_RequestExpr(Restify::RequestNode e, Http::RouteHandler res) {
  res = e.getRouteHandler()
}
