import javascript

query predicate test_HeaderDefinition_getNameExpr(
  Http::ExplicitHeaderDefinition hd, DataFlow::Node res
) {
  hd.getRouteHandler() instanceof Express::RouteHandler and res = hd.getNameNode()
}
