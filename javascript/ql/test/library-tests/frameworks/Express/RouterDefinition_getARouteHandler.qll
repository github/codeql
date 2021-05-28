import javascript

query predicate test_RouterDefinition_getARouteHandler(
  Express::RouterDefinition r, https::RouteHandler res
) {
  res = r.getARouteHandler()
}
