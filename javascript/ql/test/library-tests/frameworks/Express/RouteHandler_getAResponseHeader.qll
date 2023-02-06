import javascript

query predicate test_RouteHandler_getAResponseHeader(
  Express::RouteHandler rh, string name, Http::HeaderDefinition res
) {
  res = rh.getAResponseHeader(name)
}
