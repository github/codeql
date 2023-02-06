import javascript

query predicate test_RouterDefinition_getMiddlewareStack(
  Express::RouterDefinition r, Express::RouteHandlerNode res
) {
  res = r.getMiddlewareStack()
}
