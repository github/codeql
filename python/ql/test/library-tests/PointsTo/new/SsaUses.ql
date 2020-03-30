import python
import semmle.python.pointsto.PointsTo
import Util

from EssaVariable var, ControlFlowNode use
where use = var.getAUse() and not var.getSourceVariable() instanceof SpecialSsaSourceVariable
select locate(use.getLocation(), "abdeghjks_"), var.getRepresentation(), use.toString()
