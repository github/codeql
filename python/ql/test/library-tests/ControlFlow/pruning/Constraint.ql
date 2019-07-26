
import python

import semmle.python.Pruning

from Pruner::Constraint c, SsaVariable var, Pruner::UnprunedCfgNode node, int line, string kind
where line = node.getNode().getLocation().getStartLine() and line > 0 and
(
    c = Pruner::constraintFromTest(var, node) and kind = "test"
    or
    c = Pruner::constraintFromAssignment(var, node) and kind = "assign"
)
select line, node.getNode().toString(), var.getId(), c, kind

