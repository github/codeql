import javascript

query predicate test_ResponseExpr(Express::ResponseNode e, Http::RouteHandler res) {
  res = e.getRouteHandler()
}
