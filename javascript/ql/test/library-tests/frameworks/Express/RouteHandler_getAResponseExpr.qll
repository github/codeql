import javascript

query predicate test_RouteHandler_getAResponseExpr(Express::RouteHandler rh, HTTP::ResponseExpr res) {
  res = rh.getAResponseExpr()
}
