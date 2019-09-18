import semmle.javascript.frameworks.React

query predicate test_ReactComponent_ref(ReactComponent c, DataFlow::Node res) { res = c.ref() }
