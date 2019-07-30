import python
import semmle.python.security.TaintTracking
import semmle.python.dataflow.Implementation
import TaintLib


from TaintTrackingNode n
select n.getTaintKind(), n.getLocation().toString(), n.getNode().toString(), n.getPath().toString(), n.getContext().toString()

