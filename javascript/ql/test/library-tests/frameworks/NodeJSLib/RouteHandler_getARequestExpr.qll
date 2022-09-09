import javascript

query predicate test_RouteHandler_getARequestExpr(NodeJSLib::RouteHandler rh, HTTP::RequestNode res) {
  res = rh.getARequestNode()
}
