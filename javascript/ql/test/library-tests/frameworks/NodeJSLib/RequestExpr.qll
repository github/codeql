import javascript

query predicate test_RequestExpr(NodeJSLib::RequestExpr e, https::RouteHandler res) {
  res = e.getRouteHandler()
}
