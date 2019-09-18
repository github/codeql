import javascript

query predicate test_getAPropertyReference(DataFlow::SourceNode nd, DataFlow::PropRef res) {
  res = nd.getAPropertyReference()
}
