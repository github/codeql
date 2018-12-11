
import python
import semmle.dataflow.SSA
import semmle.python.pointsto.PointsTo
import Util

from SsaSourceVariable var, ControlFlowNode use
where use = var.getAUse() or var.hasRefinement(use, _)
select locate(use.getLocation(), "abd"), var.getName(), use.toString()
