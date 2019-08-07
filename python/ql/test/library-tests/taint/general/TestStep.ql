import python
import semmle.python.security.TaintTracking
import TaintLib


from TaintedNode n, TaintedNode s, string label
where
    s = n.getASuccessor(label)
select
    n.getTaintKind(), n.getLocation().toString(), n.getNode().toString(), n.getContext(),
    "- " + label + " ->",
    s.getTaintKind(), s.getLocation().toString(), s.getNode().toString(), s.getContext()
