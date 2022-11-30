import javascript

query predicate test_ServerDefinition_getARouteHandler(
  NodeJSLib::ServerDefinition s, Http::RouteHandler res
) {
  res = s.getARouteHandler()
}
