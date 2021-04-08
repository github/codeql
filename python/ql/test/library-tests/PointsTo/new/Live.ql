import python
import semmle.python.essa.SsaCompute
import Util

from Variable var, BasicBlock b, ControlFlowNode loc, string end
where
  Liveness::liveAtEntry(var, b) and end = "entry" and loc = b.getNode(0)
  or
  Liveness::liveAtExit(var, b) and end = "exit" and loc = b.getLastNode()
select var, locate(loc.getLocation(), "b"), end
