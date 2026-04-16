/**
 * Stronger version of NoBackwardFlow: for consecutive annotated nodes
 * A -> B that both have a single timestamp (non-loop code) and B does
 * NOT dominate A (forward edge), requires max(A) < min(B).
 */

import python
import TimerUtils

from TimerCfgNode a, TimerCfgNode b, int maxA, int minB
where
  nextTimerAnnotation(a, b) and
  not a.isDead() and
  not b.isDead() and
  // Only apply to non-loop code (single timestamps on both sides)
  strictcount(a.getATimestamp()) = 1 and
  strictcount(b.getATimestamp()) = 1 and
  // Forward edge: B does not strictly dominate A (excludes loop back-edges
  // but still checks same-basic-block pairs)
  not b.getBasicBlock().strictlyDominates(a.getBasicBlock()) and
  maxA = max(a.getATimestamp()) and
  minB = min(b.getATimestamp()) and
  maxA >= minB
select a, "Strict forward violation: $@ flows to $@", a.getTimestampExpr(maxA), "timestamp " + maxA,
  b.getTimestampExpr(minB), "timestamp " + minB
