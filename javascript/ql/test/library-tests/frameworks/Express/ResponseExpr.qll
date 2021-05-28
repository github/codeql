import javascript

query predicate test_ResponseExpr(Express::ResponseExpr e, https::RouteHandler res) {
  res = e.getRouteHandler()
}
