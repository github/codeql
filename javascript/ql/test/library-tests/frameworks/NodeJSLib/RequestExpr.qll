import javascript

query predicate test_RequestExpr(NodeJSLib::RequestNode e, HTTP::RouteHandler res) {
  res = e.getRouteHandler()
}
