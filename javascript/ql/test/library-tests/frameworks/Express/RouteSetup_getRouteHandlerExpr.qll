import javascript

query predicate test_RouteSetup_getRouteHandlerExpr(Express::RouteSetup r, int i, Expr res) {
  res = r.getRouteHandlerExpr(i)
}
