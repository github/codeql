import javascript

query predicate test_ResponseExpr(NodeJSLib::ResponseExpr e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
