
import python
import semmle.dataflow.SSA
import semmle.python.pointsto.PointsTo
import Util

from EssaVariable var, ControlFlowNode use
where use = var.getAUse()
select locate(use.getLocation(), "abdeghjks_"), var.getRepresentation(), use.toString()
