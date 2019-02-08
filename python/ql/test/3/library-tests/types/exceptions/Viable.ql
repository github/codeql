

import python

from RaisingNode r, ControlFlowNode n, ClassObject ex
where r.viableExceptionEdge(n, ex)
select r.getLocation().getStartLine(), n.getLocation().getStartLine(), r.getNode().toString(), n.getNode().toString(), ex.toString()
