/**
 * Stronger version of NoBackwardFlow: for consecutive annotated nodes
 * A -> B that both have a single timestamp (non-loop code) and B does
 * NOT dominate A (forward edge), requires max(A) < min(B).
 */

import python
import TimerUtils
import OldCfgImpl

private module Utils = EvalOrderCfgUtils<OldCfg>;

private import Utils
private import Utils::CfgTests

from TimerCfgNode a, TimerCfgNode b, int maxA, int minB
where strictForward(a, b, maxA, minB)
select a, "Strict forward violation: $@ flows to $@", a.getTimestampExpr(maxA), "timestamp " + maxA,
  b.getTimestampExpr(minB), "timestamp " + minB
