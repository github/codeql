import python
import semmle.python.security.TaintTracking
import Taint


from TaintedNode n
where n.getLocation().getFile().getShortName() = "test.py"
select "Taint " + n.getTaintKind(), n.getLocation().toString(), n.getCfgNode().getNode(), n.getContext()
