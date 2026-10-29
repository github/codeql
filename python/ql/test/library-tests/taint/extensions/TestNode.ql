import python
import ExtensionsLib

from TaintedNode n
select "Taint " + n.getTaintKind(), n.getLocation().toString(), n.getNode().asAstNode().toString(),
  n.getContext()
