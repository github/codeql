import javascript

query predicate test_RequestExpr(Hapi::RequestNode e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
