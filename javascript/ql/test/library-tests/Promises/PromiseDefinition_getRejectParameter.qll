import javascript

query predicate test_PromiseDefinition_getRejectParameter(
  PromiseDefinition pd, DataFlow::ParameterNode res
) {
  res = pd.getRejectParameter()
}
