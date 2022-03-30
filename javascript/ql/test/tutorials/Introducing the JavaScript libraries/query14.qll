import javascript

query predicate test_query14(DataFlow::InvokeNode cs, string res) {
  not cs.isIncomplete() and
  not exists(cs.getACallee()) and
  res = "Unable to find a callee for this call site."
}
