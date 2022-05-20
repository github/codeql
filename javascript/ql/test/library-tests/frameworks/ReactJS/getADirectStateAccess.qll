import semmle.javascript.frameworks.React

query predicate test_getADirectStateAccess(ReactComponent c, DataFlow::SourceNode res) {
  res = c.getADirectStateAccess()
}
