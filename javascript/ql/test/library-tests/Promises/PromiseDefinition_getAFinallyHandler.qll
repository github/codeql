import javascript

query predicate test_PromiseDefinition_getAFinallyHandler(
  PromiseDefinition pd, DataFlow::FunctionNode res
) {
  res = pd.getAFinallyHandler()
}
