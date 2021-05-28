import javascript

query predicate test_RouteHandler_getAResponseExpr(Express::RouteHandler rh, https::ResponseExpr res) {
  res = rh.getAResponseExpr()
}
