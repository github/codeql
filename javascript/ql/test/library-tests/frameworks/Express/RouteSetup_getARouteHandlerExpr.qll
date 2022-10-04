import javascript

query predicate test_RouteSetup_getARouteHandlerExpr(Express::RouteSetup r, DataFlow::Node res) {
  res = r.getARouteHandlerNode()
}
