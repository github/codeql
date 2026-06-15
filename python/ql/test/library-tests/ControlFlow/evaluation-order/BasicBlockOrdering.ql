/**
 * Checks that within a single basic block, annotations appear in
 * increasing minimum-timestamp order.
 */

import OldCfgImpl

private module Utils = EvalOrderCfgUtils<OldCfg>;

private import Utils
private import Utils::CfgTests

from TimerCfgNode a, TimerCfgNode b, int minA, int minB
where basicBlockOrdering(a, b, minA, minB)
select a, "Basic block ordering: $@ appears before $@", a.getTimestampExpr(minA),
  "timestamp " + minA, b.getTimestampExpr(minB), "timestamp " + minB
