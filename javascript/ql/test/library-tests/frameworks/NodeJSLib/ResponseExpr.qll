import javascript

query predicate test_ResponseExpr(NodeJSLib::ResponseExpr e, https::RouteHandler res) {
  res = e.getRouteHandler()
}
