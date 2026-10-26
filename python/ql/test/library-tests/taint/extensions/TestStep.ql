import python
import ExtensionsLib

from TaintedNode n, TaintedNode s
where s = n.getASuccessor()
select "Taint " + n.getTaintKind(), n.getLocation().toString(), n.getNode().asAstNode().toString(),
  n.getContext(), " --> ", "Taint " + s.getTaintKind(), s.getLocation().toString(),
  s.getNode().asAstNode().toString(), s.getContext()
