import python
import semmle.python.pointsto.PointsTo
import Util

from SsaSourceVariable var, ControlFlowNode use
where
  (use = var.getAUse() or var.hasRefinement(use, _)) and
  not var instanceof SpecialSsaSourceVariable
select locate(use.getLocation(), "abd"), var.getName(), use.toString()
