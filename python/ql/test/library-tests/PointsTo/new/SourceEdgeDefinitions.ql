
import python
import semmle.dataflow.SSA
import semmle.python.pointsto.PointsTo

import Util

from SsaSourceVariable var, ControlFlowNode use, BasicBlock pred
where var.hasRefinementEdge(use, pred, _)
select locate(pred.getLastNode().getLocation(), "ab"), var.(Variable), use.toString()
