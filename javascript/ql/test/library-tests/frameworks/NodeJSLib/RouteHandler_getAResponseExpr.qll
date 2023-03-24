import javascript

query predicate test_RouteHandler_getAResponseExpr(
  NodeJSLib::RouteHandler rh, Http::ResponseNode res
) {
  res = rh.getAResponseNode()
}
