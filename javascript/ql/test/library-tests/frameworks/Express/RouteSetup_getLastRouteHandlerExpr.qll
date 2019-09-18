import javascript

query predicate test_RouteSetup_getLastRouteHandlerExpr(Express::RouteSetup r, Expr res) {
  res = r.getLastRouteHandlerExpr()
}
