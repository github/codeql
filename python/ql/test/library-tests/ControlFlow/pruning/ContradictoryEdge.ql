
import python

import semmle.python.Pruning

from Pruner::UnprunedBasicBlock pred, Pruner::UnprunedBasicBlock succ, int line1, int line2
where Pruner::contradictoryEdge(pred, succ) and
line1 = pred.last().getNode().getLocation().getStartLine() and
line2 = succ.first().getNode().getLocation().getStartLine() and
line1 > 0
select line1, pred.last().getNode().toString(), line2, succ.first().getNode().toString()

