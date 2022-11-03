import javascript

query predicate test_RouteHandler_getARequestExpr(Express::RouteHandler rh, HTTP::RequestExpr res) {
  res = rh.getARequestExpr()
}
