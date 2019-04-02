import python
import semmle.python.security.TaintTest
import TaintLib


from EssaDefinition defn, TaintedNode n
where TaintFlowTest::tainted_def(defn, _, n)
select 
    defn.getLocation().toString(), defn.getRepresentation(), n.getLocation().toString(), n.getTrackedValue(), n.getNode().getNode().toString()
