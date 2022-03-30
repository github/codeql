import javascript

query predicate test_RequestExpr(NodeJSLib::RequestExpr e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
