import javascript

query predicate test_ResolvedPromiseDefinition(PromiseCreationCall resolved, DataFlow::Node res) {
  res = resolved.getValue()
}
