import javascript

query predicate test_RouteHandlerExpr_getBody(
  Express::RouteHandlerExpr rhe, Express::RouteHandler res
) {
  res = rhe.getBody()
}
