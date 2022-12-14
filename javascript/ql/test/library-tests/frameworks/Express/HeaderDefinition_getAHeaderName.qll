import javascript

query predicate test_HeaderDefinition_getAHeaderName(Http::HeaderDefinition hd, string res) {
  hd.getRouteHandler() instanceof Express::RouteHandler and res = hd.getAHeaderName()
}
