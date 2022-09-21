import javascript

query predicate test_ResponseExpr(Restify::ResponseNode e, Http::RouteHandler res) {
  res = e.getRouteHandler()
}
