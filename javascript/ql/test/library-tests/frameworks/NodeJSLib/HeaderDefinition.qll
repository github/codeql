import javascript

query predicate test_HeaderDefinition(Http::HeaderDefinition hd, NodeJSLib::RouteHandler rh) {
  rh = hd.getRouteHandler()
}
