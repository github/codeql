/**
 * Checks that within a single basic block, annotations appear in
 * increasing minimum-timestamp order.
 */

import python
import TimerUtils

from TimerCfgNode a, TimerCfgNode b, int minA, int minB
where
  exists(BasicBlock bb, int i, int j | a = bb.getNode(i) and b = bb.getNode(j) and i < j) and
  minA = min(a.getATimestamp()) and
  minB = min(b.getATimestamp()) and
  minA >= minB
select a, "Basic block ordering: $@ appears before $@", a.getTimestampExpr(minA),
  "timestamp " + minA, b.getTimestampExpr(minB), "timestamp " + minB
