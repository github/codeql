import semmle.javascript.frameworks.React

query predicate test_ReactComponent_getInstanceMethod(ReactComponent c, string n, Function res) {
  res = c.getInstanceMethod(n)
}
