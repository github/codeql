import javascript

query predicate test_HeaderDefinition_getNameExpr(
  Http::ExplicitHeaderDefinition hd, DataFlow::Node res
) {
  hd.getRouteHandler() instanceof NodeJSLib::RouteHandler and res = hd.getNameNode()
}
