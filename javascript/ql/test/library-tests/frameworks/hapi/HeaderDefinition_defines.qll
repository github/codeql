import javascript

query predicate test_HeaderDefinition_defines(HTTP::HeaderDefinition hd, string name, string value) {
  hd.defines(name, value) and hd.getRouteHandler() instanceof Hapi::RouteHandler
}
