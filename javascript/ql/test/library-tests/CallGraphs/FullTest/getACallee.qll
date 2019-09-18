import javascript

query predicate test_getACallee(DataFlow::InvokeNode c, Function res) { res = c.getACallee() }
