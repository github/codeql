import javascript

query predicate test_getAPropertyWrite2(
  DataFlow::SourceNode nd, string prop, DataFlow::PropWrite res
) {
  res = nd.getAPropertyWrite(prop)
}
