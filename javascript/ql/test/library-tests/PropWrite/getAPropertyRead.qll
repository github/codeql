import javascript

query predicate test_getAPropertyRead(DataFlow::SourceNode nd, DataFlow::PropRead res) {
  res = nd.getAPropertyRead()
}
