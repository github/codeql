import javascript

query predicate test_getCalleeNode(DataFlow::InvokeNode invk, DataFlow::Node res) {
  res = invk.getCalleeNode()
}
