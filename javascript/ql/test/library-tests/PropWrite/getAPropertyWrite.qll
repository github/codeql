import javascript

query predicate test_getAPropertyWrite(DataFlow::SourceNode nd, DataFlow::PropWrite res) {
  res = nd.getAPropertyWrite()
}
