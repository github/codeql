import javascript

query predicate test_PromiseDefinition_getACatchHandler(
  PromiseDefinition pd, DataFlow::FunctionNode res
) {
  res = pd.getACatchHandler()
}
