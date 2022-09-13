import javascript

query predicate test_RouteSetup_getLastRouteHandlerExpr(Express::RouteSetup r, DataFlow::Node res) {
  res = r.getLastRouteHandlerNode()
}
