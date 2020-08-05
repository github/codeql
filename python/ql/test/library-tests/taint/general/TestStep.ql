import python
import semmle.python.dataflow.TaintTracking
import TaintLib

from TaintedNode n, TaintedNode s
where s = n.getASuccessor()
select n.toString(), n.getLocation().toString(), n.getNode().toString(), n.getContext(), "-->",
  s.toString(), s.getLocation().toString(), s.getNode().toString(), s.getContext()
