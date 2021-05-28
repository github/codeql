import javascript

query predicate test_ServerDefinition_getARouteHandler(
  NodeJSLib::ServerDefinition s, https::RouteHandler res
) {
  res = s.getARouteHandler()
}
