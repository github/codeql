import javascript

query predicate test_RouteHandler_getAResponseExpr(
  NodeJSLib::RouteHandler rh, HTTP::ResponseExpr res
) {
  res = rh.getAResponseExpr()
}
