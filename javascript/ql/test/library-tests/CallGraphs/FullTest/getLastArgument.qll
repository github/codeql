import javascript

query predicate test_getLastArgument(DataFlow::InvokeNode invk, DataFlow::Node res) {
  res = invk.getLastArgument()
}
