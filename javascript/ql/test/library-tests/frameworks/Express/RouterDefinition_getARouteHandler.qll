import javascript

query predicate test_RouterDefinition_getARouteHandler(
  Express::RouterDefinition r, HTTP::RouteHandler res
) {
  res = r.getARouteHandler()
}
