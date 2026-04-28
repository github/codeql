/**
 * New-CFG version of BranchTimestamps.
 *
 * Checks that when a node has both a true and false successor, the
 * live timestamps on one branch are marked as dead on the other.
 * This ensures that boolean branches are fully annotated with dead()
 * markers for the paths not taken.
 */

import python
import TimerUtils
import NewCfgImpl

private module Utils = EvalOrderCfgUtils<NewCfg>;

private import Utils
private import Utils::CfgTests

from TimerCfgNode node, int ts, string branch
where missingBranchTimestamp(node, ts, branch)
select node,
  "Timestamp " + ts + " on true/false branch is missing a dead() annotation on the " + branch +
    " successor in $@", node.getTestFunction(), node.getTestFunction().getName()
