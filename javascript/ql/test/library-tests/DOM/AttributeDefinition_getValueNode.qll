import javascript

query predicate test_AttributeDefinition_getValueNode(DOM::AttributeDefinition a, DataFlow::Node res) {
  res = a.getValueNode()
}
