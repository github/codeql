import javascript

query predicate test_getAnArgument(DataFlow::InvokeNode invk, DataFlow::Node res) {
  res = invk.getAnArgument()
}
