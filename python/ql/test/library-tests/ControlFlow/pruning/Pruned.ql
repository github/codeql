
import python

import semmle.python.Pruning

from Pruner::UnprunedCfgNode pred, Pruner::UnprunedCfgNode succ, int line1, int line2
where Pruner::unreachableEdge(pred, succ) and
line1 = pred.getNode().getLocation().getStartLine() and
line2 = succ.getNode().getLocation().getStartLine() and
line1 > 0
select line1, pred.getNode().toString(), line2, succ.getNode().toString()

