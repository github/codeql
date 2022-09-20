import javascript

query predicate test_RouteHandler_getAResponseExpr(Express::RouteHandler rh, Http::ResponseNode res) {
  res = rh.getAResponseNode()
}
