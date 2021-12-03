import semmle.javascript.frameworks.React

query predicate test_ReactComponent_getAPropRead(ReactComponent c, string n, DataFlow::PropRead res) {
  res = c.getAPropRead(n)
}
