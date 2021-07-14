import javascript

query predicate test_RouteHandler(Express::RouteHandler rh, Parameter res0, Parameter res1) {
  res0 = rh.getRequestParameter() and res1 = rh.getResponseParameter()
}
