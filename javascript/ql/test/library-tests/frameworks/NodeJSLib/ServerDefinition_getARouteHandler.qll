import javascript

query predicate test_ServerDefinition_getARouteHandler(
  NodeJSLib::ServerDefinition s, HTTP::RouteHandler res
) {
  res = s.getARouteHandler()
}
