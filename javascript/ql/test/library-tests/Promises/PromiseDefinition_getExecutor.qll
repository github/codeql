import javascript

query predicate test_PromiseDefinition_getExecutor(PromiseDefinition pd, DataFlow::FunctionNode res) {
  res = pd.getExecutor()
}
