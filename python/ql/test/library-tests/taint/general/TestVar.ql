import python
import semmle.python.security.TaintTest
import TaintLib


from EssaVariable var, TaintedNode n
where TaintFlowTest::tainted_var(var, _, n)
select 
    var.getDefinition().getLocation().toString(), var.getRepresentation(), n.getLocation().toString(), n.getTrackedValue(), n.getNode().getNode().toString()
