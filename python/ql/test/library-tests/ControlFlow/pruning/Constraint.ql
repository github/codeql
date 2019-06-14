
import python

import semmle.python.Pruning

from Pruner::Constraint c, SsaVariable var, Pruner::UnprunedCfgNode node, int line
where c = Pruner::constraintFromTest(var, node) and line = node.getNode().getLocation().getStartLine() and
line > 0
select line, node.getNode().toString(), var.getId(), c

