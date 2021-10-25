import javascript

query predicate test_getAFunctionValue(DataFlow::Node node, DataFlow::FunctionNode res) {
  res = node.getAFunctionValue()
}
