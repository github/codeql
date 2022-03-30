import javascript

query predicate test_ResponseExpr(Hapi::ResponseExpr e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
