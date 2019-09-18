import javascript

query predicate test_ReactComponent_getACandidatePropsValue(DataFlow::Node res) {
  exists(ReactComponent c | res = c.getACandidatePropsValue(_))
}
