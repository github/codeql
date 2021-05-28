import javascript

query predicate test_RouteHandler_getAResponseExpr(
  NodeJSLib::RouteHandler rh, https::ResponseExpr res
) {
  res = rh.getAResponseExpr()
}
