import semmle.javascript.frameworks.Express

query predicate test_RouteHandler_getAResponseHeader(
  Connect::RouteHandler rh, string name, HTTP::HeaderDefinition res
) {
  res = rh.getAResponseHeader(name)
}
