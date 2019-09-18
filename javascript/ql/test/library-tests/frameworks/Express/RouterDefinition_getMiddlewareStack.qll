import javascript

query predicate test_RouterDefinition_getMiddlewareStack(
  Express::RouterDefinition r, Express::RouteHandlerExpr res
) {
  res = r.getMiddlewareStack()
}
