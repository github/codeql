import javascript

query predicate test_ResponseExpr(Restify::ResponseExpr e, https::RouteHandler res) {
  res = e.getRouteHandler()
}
