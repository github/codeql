import javascript

query predicate test_HeaderDefinition_getNameExpr(https::ExplicitHeaderDefinition hd, Expr res) {
  hd.getRouteHandler() instanceof Express::RouteHandler and res = hd.getNameExpr()
}
