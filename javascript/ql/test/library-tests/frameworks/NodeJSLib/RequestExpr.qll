import javascript

query predicate test_RequestExpr(NodeJSLib::RequestNode e, Http::RouteHandler res) {
  res = e.getRouteHandler()
}
