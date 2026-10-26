import javascript

query predicate test_RouterDefinition_getARouteHandler(
  Express::RouterDefinition r, Http::RouteHandler res
) {
  res = r.getARouteHandler()
}
