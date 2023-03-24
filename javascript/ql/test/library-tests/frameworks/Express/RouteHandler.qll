import javascript

query predicate test_RouteHandler(
  Express::RouteHandler rh, DataFlow::ParameterNode res0, DataFlow::ParameterNode res1
) {
  res0 = rh.getRequestParameter() and res1 = rh.getResponseParameter()
}
