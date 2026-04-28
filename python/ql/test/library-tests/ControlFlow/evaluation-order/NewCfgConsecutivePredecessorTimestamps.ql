/**
 * New-CFG version of ConsecutivePredecessorTimestamps.
 *
 * Checks that each annotated node (except the minimum timestamp) has
 * a predecessor annotation with timestamp `a - 1`. This is the reverse
 * of ConsecutiveTimestamps: it catches nodes that are reachable but
 * arrived at from the wrong place (skipping an intermediate node).
 */

import python
import TimerUtils
import NewCfgImpl

private module Utils = EvalOrderCfgUtils<NewCfg>;

private import Utils
private import Utils::CfgTests

from TimerAnnotation ann, int a
where consecutivePredecessorTimestamps(ann, a)
select ann, "$@ in $@ has no consecutive predecessor (expected " + (a - 1) + ")",
  ann.getTimestampExpr(a), "Timestamp " + a, ann.getTestFunction(), ann.getTestFunction().getName()
