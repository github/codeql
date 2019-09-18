import semmle.javascript.frameworks.React

query predicate test_ReactComponent_getACandidateStateSource(
  ReactComponent c, DataFlow::SourceNode res
) {
  res = c.getACandidateStateSource()
}
