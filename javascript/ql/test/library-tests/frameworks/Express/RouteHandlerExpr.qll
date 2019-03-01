import javascript

query predicate test_RouteHandlerExpr(
  Express::RouteHandlerExpr rhe, Express::RouteSetup res0, boolean isLast
) {
  (if rhe.isLastHandler() then isLast = true else isLast = false) and
  res0 = rhe.getSetup()
}
