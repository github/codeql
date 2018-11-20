import python
import semmle.python.security.TaintTest
import TaintLib

from TaintFlowTest::TrackedValue taint, CallContext c, ControlFlowNode n, string what
where
not exists(TaintedNode t | t.getTrackedValue() = taint and t.getNode() = n and t.getContext() = c) and
(
    TaintFlowTest::step(_, taint, c, n) and what = "missing node at end of step"
    or
    n.(TaintSource).isSourceOf(taint.(TaintFlowTest::TrackedTaint).getKind(), c) and what = "missing node for source"

)
or
exists(TaintedNode t | t.getTrackedValue() = taint and t.getNode() = n and t.getContext() = c
    |
    not TaintFlowTest::step(_, taint, c, n) and 
    not n.(TaintSource).isSourceOf(taint.(TaintFlowTest::TrackedTaint).getKind(), c) and what = "TaintedNode with no reason"
    or
    TaintFlowTest::step(t, taint, c, n) and what = "step ends where it starts"
    or
    TaintFlowTest::step(t,  _, _, _) and not TaintFlowTest::step(_, taint, c, n) and
    not n.(TaintSource).isSourceOf(taint.(TaintFlowTest::TrackedTaint).getKind(), c) and what = "No predecessor and not a source"
)

select n.getLocation(), taint, c, n.toString(), what
