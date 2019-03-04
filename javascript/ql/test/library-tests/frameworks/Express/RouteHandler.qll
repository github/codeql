import javascript

query predicate test_RouteHandler(
  Express::RouteHandler rh, SimpleParameter res0, SimpleParameter res1
) {
  res0 = rh.getRequestParameter() and res1 = rh.getResponseParameter()
}
