import javascript

query predicate test_ResponseExpr(Restify::ResponseNode e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
