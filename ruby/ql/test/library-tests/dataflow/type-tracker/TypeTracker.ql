import ruby
import codeql.ruby.DataFlow
import codeql.ruby.typetracking.TypeTracker

class LocalSourceNode extends DataFlow::LocalSourceNode {
  LocalSourceNode() { this.getLocation().getFile().getExtension() = "rb" }
}

query LocalSourceNode track(LocalSourceNode src, TypeTracker t) {
  t.start() and
  result = src
  or
  exists(TypeTracker t2 | result = track(src, t2).track(t2, t))
}

query LocalSourceNode trackEnd(LocalSourceNode src) { result = track(src, TypeTracker::end()) }

LocalSourceNode backtrack(LocalSourceNode sink, TypeBackTracker t) {
  t.start() and
  result = sink
  or
  exists(TypeBackTracker t2 | result = backtrack(sink, t2).backtrack(t2, t))
}

LocalSourceNode backtrackEnd(LocalSourceNode sink) {
  result = backtrack(sink, TypeBackTracker::end())
}

query predicate forwardButNoBackwardFlow(LocalSourceNode src, LocalSourceNode sink) {
  sink = trackEnd(src) and
  not src = backtrackEnd(sink)
}

query predicate backwardButNoForwardFlow(LocalSourceNode src, LocalSourceNode sink) {
  src = backtrackEnd(sink) and
  not sink = trackEnd(src)
}
