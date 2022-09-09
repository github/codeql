import javascript

query predicate test_RouteHandler_getARequestExpr(Express::RouteHandler rh, Http::RequestNode res) {
  res = rh.getARequestNode()
}
