import javascript

query predicate test_PromiseDefinition_getResolveParameter(
  PromiseDefinition pd, DataFlow::ParameterNode res
) {
  res = pd.getResolveParameter()
}
