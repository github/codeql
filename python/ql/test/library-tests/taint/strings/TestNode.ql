import python
import semmle.python.security.TaintTracking
import Taint


from TaintedNode n
where n.getLocation().getFile().getName().matches("%test.py")
select n.getTrackedValue(), n.getLocation().toString(), n.getAstNode(), n.getContext()

