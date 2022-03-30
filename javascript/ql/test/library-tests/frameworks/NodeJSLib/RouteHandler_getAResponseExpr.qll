import javascript

query predicate test_RouteHandler_getAResponseExpr(
  NodeJSLib::RouteHandler rh, HTTP::ResponseNode res
) {
  res = rh.getAResponseNode()
}
