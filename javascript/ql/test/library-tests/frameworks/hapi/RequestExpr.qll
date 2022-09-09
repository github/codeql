import javascript

query predicate test_RequestExpr(Hapi::RequestNode e, Http::RouteHandler res) {
  res = e.getRouteHandler()
}
