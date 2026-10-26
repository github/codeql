import javascript

query predicate test_RouteHandler_getARequestExpr(NodeJSLib::RouteHandler rh, Http::RequestNode res) {
  res = rh.getARequestNode()
}
