import javascript

query predicate test_getNumArgument(DataFlow::InvokeNode invk, int res) {
  res = invk.getNumArgument()
}
