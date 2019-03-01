import javascript

query predicate test_HeaderDefinition(HTTP::HeaderDefinition hd, NodeJSLib::RouteHandler rh) {
  rh = hd.getRouteHandler()
}
