import python
import Config

from TaintedNode n
select "Taint " + n.getTaintKind(), n.getLocation().toString(), n.getNode().getNode().toString(),
  n.getContext()
