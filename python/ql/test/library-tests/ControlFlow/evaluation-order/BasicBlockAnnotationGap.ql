/**
 * Checks that within a basic block, if a node is annotated then its
 * successor is also annotated (or excluded). A gap in annotations
 * within a basic block indicates a missing annotation, since there
 * are no branches to justify the gap.
 *
 * Nodes with exceptional successors are excluded, as the exception
 * edge leaves the basic block and the normal successor may be dead.
 */

import python
import TimerUtils

from TimerCfgNode a, ControlFlowNode succ
where
  exists(BasicBlock bb, int i |
    a = bb.getNode(i) and
    succ = bb.getNode(i + 1)
  ) and
  not succ instanceof TimerCfgNode and
  not isUnannotatable(succ.getNode()) and
  not isTimerMechanism(succ.getNode(), a.getTestFunction()) and
  not exists(a.getAnExceptionalSuccessor()) and
  succ.getNode() instanceof Expr
select a, "Annotated node followed by unannotated $@ in the same basic block", succ,
  succ.getNode().toString()
