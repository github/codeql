import javascript

query predicate test_ResponseExpr(Hapi::ResponseExpr e, https::RouteHandler res) {
  res = e.getRouteHandler()
}
