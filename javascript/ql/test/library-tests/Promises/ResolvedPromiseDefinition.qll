import javascript

query predicate test_ResolvedPromiseDefinition(
  ResolvedPromiseDefinition resolved, DataFlow::Node res
) {
  res = resolved.getValue()
}
