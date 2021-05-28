import javascript

query predicate test_RequestExpr(Hapi::RequestExpr e, https::RouteHandler res) {
  res = e.getRouteHandler()
}
