import javascript

query predicate test_RouteHandler_getARequestExpr(Express::RouteHandler rh, https::RequestExpr res) {
  res = rh.getARequestExpr()
}
