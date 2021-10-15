import semmle.javascript.frameworks.React

query predicate test_ReactComponent_getADirectPropsSource(ReactComponent c, DataFlow::SourceNode res) {
  res = c.getADirectPropsAccess()
}
