import javascript

query predicate test_HeaderDefinition_getAHeaderName(Http::HeaderDefinition hd, string res) {
  hd.getRouteHandler() instanceof Hapi::RouteHandler and res = hd.getAHeaderName()
}
