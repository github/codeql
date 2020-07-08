import python
import semmle.python.dataflow.TaintTracking
import semmle.python.dataflow.Implementation
import TaintLib

from
  TaintKind taint, TaintTrackingContext c, DataFlow::Node n, string what,
  TaintTrackingImplementation impl
where
  not exists(TaintedNode t | t.getTaintKind() = taint and t.getNode() = n and t.getContext() = c) and
  (
    impl.flowStep(_, n, c, _, taint, _) and what = "missing node at end of step"
    or
    impl.flowSource(n, c, _, taint) and what = "missing node for source"
  )
  or
  exists(TaintedNode t | t.getTaintKind() = taint and t.getNode() = n and t.getContext() = c |
    not impl.flowStep(_, n, c, _, taint, _) and
    not impl.flowSource(n, c, _, taint) and
    what = "TaintedNode with no reason"
    or
    impl.flowStep(t, n, c, _, taint, _) and what = "step ends where it starts"
    or
    impl.flowStep(t, _, _, _, _, _) and
    not impl.flowStep(_, n, c, _, taint, _) and
    not impl.flowSource(n, c, _, taint) and
    what = "No predecessor and not a source"
  )
select n.getLocation(), taint, c, n.toString(), what
