import javascript

query predicate test_getAPropertyRead2(DataFlow::SourceNode nd, string prop, DataFlow::PropRead res) {
  res = nd.getAPropertyRead(prop)
}
