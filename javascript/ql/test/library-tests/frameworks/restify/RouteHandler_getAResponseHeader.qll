import semmle.javascript.frameworks.Express

query predicate test_RouteHandler_getAResponseHeader(
  Restify::RouteHandler rh, string name, Http::HeaderDefinition res
) {
  res = rh.getAResponseHeader(name)
}
