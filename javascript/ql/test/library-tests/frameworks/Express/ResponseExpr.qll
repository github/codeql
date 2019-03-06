import javascript

query predicate test_ResponseExpr(Express::ResponseExpr e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
