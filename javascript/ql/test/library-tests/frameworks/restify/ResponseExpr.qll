import javascript

query predicate test_ResponseExpr(Restify::ResponseExpr e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
