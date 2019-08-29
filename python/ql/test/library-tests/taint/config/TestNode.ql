import python
import semmle.python.security.TaintTracking
import semmle.python.dataflow.Implementation
import TaintLib


from TaintTrackingNode n
where n.getConfiguration() instanceof TestConfig
select n.getLocation().toString(), n.getTaintKind(), n.getNode().toString(), n.getPath().toString(), n.getContext().toString()

