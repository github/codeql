import javascript

query predicate test_RouteSetup_getARouteHandlerExpr(Express::RouteSetup r, Expr res) {
  res = r.getARouteHandlerExpr()
}
