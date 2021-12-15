import javascript

query predicate test_HeaderDefinition_getAHeaderName(HTTP::HeaderDefinition hd, string res) {
  hd.getRouteHandler() instanceof Hapi::RouteHandler and res = hd.getAHeaderName()
}
