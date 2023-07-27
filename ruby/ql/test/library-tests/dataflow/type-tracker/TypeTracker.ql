import codeql.ruby.AST
import codeql.ruby.DataFlow

class LocalSourceNode extends DataFlow::LocalSourceNode {
  LocalSourceNode() { this.getLocation().getFile().getExtension() = "rb" }
}

query predicate track(LocalSourceNode src, DataFlow::TypeTracker t, LocalSourceNode dst) {
  t.start() and
  dst = src
  or
  exists(DataFlow::TypeTracker t2, LocalSourceNode mid |
    track(src, t2, mid) and dst = mid.track(t2, t)
  )
}

query predicate trackEnd(LocalSourceNode src, DataFlow::Node dst) {
  exists(LocalSourceNode end |
    track(src, DataFlow::TypeTracker::end(), end) and
    end.flowsTo(dst)
  )
}

predicate backtrack(LocalSourceNode sink, DataFlow::TypeBackTracker t, LocalSourceNode src) {
  t.start() and
  sink.getALocalSource() = src
  or
  exists(DataFlow::TypeBackTracker t2, LocalSourceNode mid |
    backtrack(sink, t2, mid) and
    src = mid.backtrack(t2, t)
  )
}

predicate backtrackEnd(LocalSourceNode sink, LocalSourceNode src) {
  backtrack(sink, DataFlow::TypeBackTracker::end(), src)
}

query predicate forwardButNoBackwardFlow(LocalSourceNode src, LocalSourceNode sink) {
  trackEnd(src, sink) and
  not backtrackEnd(sink, src)
}

query predicate backwardButNoForwardFlow(LocalSourceNode src, LocalSourceNode sink) {
  backtrackEnd(sink, src) and
  not trackEnd(src, sink)
}
