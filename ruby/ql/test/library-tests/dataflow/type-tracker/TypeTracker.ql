import ruby
import codeql.ruby.DataFlow
import codeql.ruby.typetracking.TypeTracker

class LocalSourceNode extends DataFlow::LocalSourceNode {
  LocalSourceNode() { this.getLocation().getFile().getExtension() = "rb" }
}

query predicate track(LocalSourceNode src, TypeTracker t, LocalSourceNode dst) {
  t.start() and
  dst = src
  or
  exists(TypeTracker t2, LocalSourceNode mid | track(src, t2, mid) and dst = mid.track(t2, t))
}

query predicate trackEnd(LocalSourceNode src, DataFlow::Node dst) {
  exists(LocalSourceNode end |
    track(src, TypeTracker::end(), end) and
    end.flowsTo(dst)
  )
}
