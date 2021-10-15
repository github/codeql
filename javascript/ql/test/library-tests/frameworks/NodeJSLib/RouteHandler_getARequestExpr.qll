import javascript

query predicate test_RouteHandler_getARequestExpr(NodeJSLib::RouteHandler rh, HTTP::RequestExpr res) {
  res = rh.getARequestExpr()
}
