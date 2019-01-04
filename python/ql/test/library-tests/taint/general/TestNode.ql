import python
import semmle.python.security.TaintTracking
import TaintLib


from TaintedNode n
select n.getTrackedValue(), n.getLocation().toString(), n.getNode().getNode().toString(), n.getContext()

