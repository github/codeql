import javascript

query predicate test_HeaderDefinition_getNameExpr(HTTP::ExplicitHeaderDefinition hd, Expr res) {
  hd.getRouteHandler() instanceof NodeJSLib::RouteHandler and res = hd.getNameExpr()
}
