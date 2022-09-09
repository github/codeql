import javascript

query predicate test_RouteHandler_getARequestExpr(Express::RouteHandler rh, HTTP::RequestNode res) {
  res = rh.getARequestNode()
}
