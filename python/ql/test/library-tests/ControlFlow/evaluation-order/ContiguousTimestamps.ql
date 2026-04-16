/**
 * Checks that timestamps form a contiguous sequence {0, 1, ..., max}
 * within each test function. Every integer in the range must appear
 * in at least one annotation (live or dead).
 */

import python
import TimerUtils

from TestFunction f, int missing, int maxTs, TimerAnnotation maxAnn
where
  maxTs = max(TimerAnnotation a | a.getTestFunction() = f | a.getATimestamp()) and
  maxAnn.getTestFunction() = f and
  maxAnn.getATimestamp() = maxTs and
  missing = [0 .. maxTs] and
  not exists(TimerAnnotation a | a.getTestFunction() = f and a.getATimestamp() = missing)
select f, "Missing timestamp " + missing + " (max is $@)", maxAnn.getTimestampExpr(maxTs),
  maxTs.toString()
