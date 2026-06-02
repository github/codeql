/**
 * New-CFG version of BasicBlockAnnotationGap.
 *
 * Original:
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
import NewCfgImpl

private module Utils = EvalOrderCfgUtils<NewCfg>;

private import Utils
private import Utils::CfgTests

from TimerCfgNode a, CfgNode succ
where basicBlockAnnotationGap(a, succ)
select a, "Annotated node followed by unannotated $@ in the same basic block", succ,
  succ.getNode().toString()
