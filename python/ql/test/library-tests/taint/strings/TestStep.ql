import python
import semmle.python.security.TaintTracking
import Taint


from TaintedNode n, TaintedNode s
where n.getLocation().getFile().getName().matches("%test.py") and
s.getLocation().getFile().getName().matches("%test.py") and
s = n.getASuccessor()
select 
    n.getTrackedValue(), n.getLocation().toString(), n.getNode().getNode(), n.getContext(), 
    " --> ",
    s.getTrackedValue(), s.getLocation().toString(), s.getNode().getNode(), s.getContext()
