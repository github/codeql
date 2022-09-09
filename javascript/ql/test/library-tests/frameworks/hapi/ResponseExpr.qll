import javascript

query predicate test_ResponseExpr(Hapi::ResponseNode e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
