import javascript

query predicate test_RouteHandler_getARequestExpr(NodeJSLib::RouteHandler rh, https::RequestExpr res) {
  res = rh.getARequestExpr()
}
