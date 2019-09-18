import javascript

query predicate test_getAPropertyReference2(
  DataFlow::SourceNode nd, string prop, DataFlow::PropRef res
) {
  res = nd.getAPropertyReference(prop)
}
