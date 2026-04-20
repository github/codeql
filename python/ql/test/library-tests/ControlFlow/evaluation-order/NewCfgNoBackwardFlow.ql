/**
 * New-CFG version of NoBackwardFlow.
 *
 * Original:
 * Checks that time never flows backward between consecutive timer annotations
 * in the CFG. For each pair of consecutive annotated nodes (A -> B), there must
 * exist timestamps a in A and b in B with a < b.
 */

import python
import TimerUtils
import NewCfgImpl

private module Utils = EvalOrderCfgUtils<NewCfg>;

private import Utils
private import Utils::CfgTests

from TimerCfgNode a, TimerCfgNode b, int minA, int maxB
where noBackwardFlow(a, b, minA, maxB)
select a, "Backward flow: $@ flows to $@ (max timestamp $@)", a.getTimestampExpr(minA),
  minA.toString(), b, b.getNode().toString(), b.getTimestampExpr(maxB), maxB.toString()
