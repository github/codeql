import javascript

query predicate test_isUncertain(DataFlow::InvokeNode invk) { invk.isUncertain() }

query predicate test_getAFunctionValue(DataFlow::Node node, DataFlow::FunctionNode res) {
  res = node.getAFunctionValue()
}

query predicate test_getArgument(DataFlow::InvokeNode invk, int i, DataFlow::Node res) {
  res = invk.getArgument(i)
}

query predicate test_getNumArgument(DataFlow::InvokeNode invk, int res) {
  res = invk.getNumArgument()
}

query predicate test_isIncomplete(DataFlow::InvokeNode invk) { invk.isIncomplete() }

query predicate test_getCalleeNode(DataFlow::InvokeNode invk, DataFlow::Node res) {
  res = invk.getCalleeNode()
}

query predicate test_getLastArgument(DataFlow::InvokeNode invk, DataFlow::Node res) {
  res = invk.getLastArgument()
}

query predicate test_getAnArgument(DataFlow::InvokeNode invk, DataFlow::Node res) {
  res = invk.getAnArgument()
}

query predicate test_getACallee(DataFlow::InvokeNode c, Function res) { res = c.getACallee() }

query predicate test_getCalleeName(DataFlow::InvokeNode invk, string res) {
  res = invk.getCalleeName()
}

query predicate test_isImprecise(DataFlow::InvokeNode invk) { invk.isImprecise() }
