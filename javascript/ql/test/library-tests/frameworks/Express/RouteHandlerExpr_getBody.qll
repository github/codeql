import javascript

query predicate test_RouteHandlerExpr_getBody(
  Express::RouteHandlerNode rhe, Express::RouteHandler res
) {
  res = rhe.getBody()
}
