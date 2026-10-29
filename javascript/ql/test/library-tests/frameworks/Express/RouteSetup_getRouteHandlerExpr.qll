import javascript

query predicate test_RouteSetup_getRouteHandlerExpr(Express::RouteSetup r, int i, DataFlow::Node res) {
  res = r.getRouteHandlerNode(i)
}
