import javascript

query predicate test_getAPropertySource(
  DataFlow::SourceNode nd, string prop, DataFlow::SourceNode res
) {
  res = nd.getAPropertySource(prop)
}
