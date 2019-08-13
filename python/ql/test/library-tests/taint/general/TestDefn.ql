import python
import semmle.python.security.TaintTest
import TaintLib


from EssaNodeDefinition defn, TaintedNode n
where n.getNode().asVariable() = defn.getVariable()
select 
    defn.getLocation().toString(), defn.getRepresentation(), n.getLocation().toString(), "Taint " + n.getTaintKind(), defn.getDefiningNode().getNode().toString()
