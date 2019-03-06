import javascript

query predicate test_getArgument(DataFlow::InvokeNode invk, int i, DataFlow::Node res) {
  res = invk.getArgument(i)
}
