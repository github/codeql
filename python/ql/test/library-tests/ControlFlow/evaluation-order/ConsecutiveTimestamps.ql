/**
 * Checks that consecutive annotated nodes have consecutive timestamps:
 * for each annotation with timestamp `a`, some CFG node for that annotation
 * must have a next annotation containing `a + 1`.
 *
 * Handles CFG splitting (e.g., finally blocks duplicated for normal/exceptional
 * flow) by checking that at least one split has the required successor.
 *
 * Only applies to functions where all annotations are in the function's
 * own scope (excludes tests with generators, async, comprehensions, or
 * lambdas that have annotations in nested scopes).
 */

import python
import TimerUtils
import OldCfgImpl

private module Utils = EvalOrderCfgUtils<OldCfg>;

private import Utils
private import Utils::CfgTests

from TimerAnnotation ann, int a
where consecutiveTimestamps(ann, a)
select ann, "$@ in $@ has no consecutive successor (expected " + (a + 1) + ")",
  ann.getTimestampExpr(a), "Timestamp " + a, ann.getTestFunction(), ann.getTestFunction().getName()
