import javascript

query predicate test_ResponseExpr(NodeJSLib::ResponseNode e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
