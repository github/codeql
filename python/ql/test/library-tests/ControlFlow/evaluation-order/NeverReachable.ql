/**
 * Checks that expressions annotated with `t.never` either have no CFG
 * node, or if they do, that the node is not reachable from its scope's
 * entry (including within the same basic block).
 */

import python
import TimerUtils

from NeverTimerAnnotation ann
where
  exists(ControlFlowNode n, Scope s |
    n.getNode() = ann.getExpr() and
    s = n.getScope() and
    (
      // Reachable via inter-block path (includes same block)
      s.getEntryNode().getBasicBlock().reaches(n.getBasicBlock())
      or
      // In same block as entry but at a later index
      exists(BasicBlock bb, int i, int j |
        bb.getNode(i) = s.getEntryNode() and bb.getNode(j) = n and i < j
      )
    )
  )
select ann, "Node annotated with t.never is reachable in $@", ann.getTestFunction(),
  ann.getTestFunction().getName()
