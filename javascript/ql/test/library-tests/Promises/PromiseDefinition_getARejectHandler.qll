import javascript

query predicate test_PromiseDefinition_getARejectHandler(
  PromiseDefinition pd, DataFlow::FunctionNode res
) {
  res = pd.getARejectHandler()
}
