/**
 * Checks that two annotations sharing a timestamp value are on
 * mutually exclusive CFG paths (neither can reach the other).
 */

import python
import TimerUtils
import OldCfgImpl

private module Utils = EvalOrderCfgUtils<OldCfg>;

private import Utils
private import Utils::CfgTests

from TimerCfgNode a, TimerCfgNode b, int ts
where noSharedReachable(a, b, ts)
select a, "Shared timestamp $@ but this node reaches $@", a.getTimestampExpr(ts), ts.toString(), b,
  b.getNode().toString()
