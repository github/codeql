import javascript

query predicate test_ResponseExpr(Express::ResponseNode e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
