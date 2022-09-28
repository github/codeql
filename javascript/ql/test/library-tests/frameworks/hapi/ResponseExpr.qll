import javascript

query predicate test_ResponseExpr(Hapi::ResponseNode e, Http::RouteHandler res) {
  res = e.getRouteHandler()
}
