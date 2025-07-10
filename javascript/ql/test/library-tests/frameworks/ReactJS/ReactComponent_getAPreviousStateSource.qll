import semmle.javascript.frameworks.React

query predicate test_ReactComponent_getAPreviousStateSource(
  ReactComponent c, DataFlow::SourceNode res
) {
  res = c.getAPreviousStateSource()
}
