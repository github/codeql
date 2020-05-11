/**
 * Compute the total call-graph facts, the total size of the call-graph relation and
 * the ratio of the two in relation to the depth of context.
 */

import python
import semmle.python.pointsto.PointsTo
import semmle.python.pointsto.PointsToContext

from int total_facts, int total_size, int depth, float efficiency
where
  total_facts =
    strictcount(ControlFlowNode call, CallableValue func |
      exists(PointsToContext ctx |
        call = func.getACall(ctx) and
        depth = ctx.getDepth()
      )
    ) and
  total_size =
    strictcount(ControlFlowNode call, CallableValue func, PointsToContext ctx |
      call = func.getACall(ctx) and
      depth = ctx.getDepth()
    ) and
  efficiency = 100.0 * total_facts / total_size
select depth, total_facts, total_size, efficiency
