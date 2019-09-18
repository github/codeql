import javascript

query predicate test_getCalleeName(DataFlow::InvokeNode invk, string res) {
  res = invk.getCalleeName()
}
