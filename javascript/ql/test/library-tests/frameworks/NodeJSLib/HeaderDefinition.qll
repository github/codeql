import javascript

query predicate test_HeaderDefinition(https::HeaderDefinition hd, NodeJSLib::RouteHandler rh) {
  rh = hd.getRouteHandler()
}
