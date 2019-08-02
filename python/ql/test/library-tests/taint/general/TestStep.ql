import python
import semmle.python.security.TaintTracking
import TaintLib


from TaintedNode n, TaintedNode s
where s = n.getASuccessor()
select 
    n.getTaintKind(), n.getLocation().toString(), n.getNode().toString(), n.getContext(), 
    " --> ",
    s.getTaintKind(), s.getLocation().toString(), s.getNode().toString(), s.getContext()
