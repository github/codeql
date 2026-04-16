/**
 * Checks that two annotations sharing a timestamp value are on
 * mutually exclusive CFG paths (neither can reach the other).
 */

import python
import TimerUtils

from TimerCfgNode a, TimerCfgNode b, int ts
where
  a != b and
  not a.isDead() and
  not b.isDead() and
  a.getTestFunction() = b.getTestFunction() and
  ts = a.getATimestamp() and
  ts = b.getATimestamp() and
  (
    a.getBasicBlock().strictlyReaches(b.getBasicBlock())
    or
    exists(BasicBlock bb, int i, int j | a = bb.getNode(i) and b = bb.getNode(j) and i < j)
  )
select a, "Shared timestamp $@ but this node reaches $@", a.getTimestampExpr(ts), ts.toString(), b,
  b.getNode().toString()
