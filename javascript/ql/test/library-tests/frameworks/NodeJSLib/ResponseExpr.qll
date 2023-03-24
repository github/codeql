import javascript

query predicate test_ResponseExpr(NodeJSLib::ResponseNode e, Http::RouteHandler res) {
  res = e.getRouteHandler()
}
