import javascript

query predicate test_RouterDefinition_getMiddlewareStackAt(
  Express::RouterDefinition r, ControlFlowNode nd, Express::RouteHandlerExpr res
) {
  res = r.getMiddlewareStackAt(nd)
}
