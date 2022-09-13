import javascript

query predicate test_RequestExpr(Restify::RequestNode e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
