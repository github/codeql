import python
import semmle.python.dataflow.TaintTracking
import Taint

from TaintedNode n, TaintedNode s
where
  n.getLocation().getFile().getShortName() = "test.py" and
  s.getLocation().getFile().getShortName() = "test.py" and
  s = n.getASuccessor()
select "Taint " + n.getTaintKind(), n.getLocation().toString(), n.getAstNode(), n.getContext(),
  " --> ", "Taint " + s.getTaintKind(), s.getLocation().toString(), s.getAstNode(), s.getContext()
