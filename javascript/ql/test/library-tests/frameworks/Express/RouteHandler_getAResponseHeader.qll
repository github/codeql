import javascript

query predicate test_RouteHandler_getAResponseHeader(
  Express::RouteHandler rh, string name, HTTP::HeaderDefinition res
) {
  res = rh.getAResponseHeader(name)
}
