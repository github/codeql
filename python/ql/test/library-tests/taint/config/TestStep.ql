import python
import semmle.python.security.TaintTracking
import TaintLib
import semmle.python.dataflow.Implementation


from TaintTrackingNode n, TaintTrackingNode s, TaintTracking::Configuration config
where s = n.getASuccessor() and config = n.getConfiguration()
select 
    config + ":", 
    n.getTaintKind(), n.getLocation().toString(), n.getNode().toString(), n.getContext(),
    " --> ",
    s.getTaintKind(), s.getLocation().toString(), s.getNode().toString(), s.getContext()
