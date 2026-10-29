import javascript

query predicate test_hasPropertyWrite(DataFlow::SourceNode src, string prop, DataFlow::Node rhs) {
  src.hasPropertyWrite(prop, rhs)
}
