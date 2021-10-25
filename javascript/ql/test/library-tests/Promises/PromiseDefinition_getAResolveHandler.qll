import javascript

query predicate test_PromiseDefinition_getAResolveHandler(
  PromiseDefinition pd, DataFlow::FunctionNode res
) {
  res = pd.getAResolveHandler()
}
