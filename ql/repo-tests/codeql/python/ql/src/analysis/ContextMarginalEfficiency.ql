/**
 * Compute the marginal increase points-to facts, the total size of the points-to relation and
 * the ratio of the two in relation to the depth of context.
 */

import python
import semmle.python.pointsto.PointsTo
import semmle.python.pointsto.PointsToContext

int depth(ControlFlowNode f, Object value, ClassObject cls) {
  exists(PointsToContext ctx |
    PointsTo::points_to(f, ctx, value, cls, _) and
    result = ctx.getDepth()
  )
}

int shallowest(ControlFlowNode f, Object value, ClassObject cls) {
  result = min(int x | x = depth(f, value, cls))
}

from int total_facts, int total_size, int depth, float efficiency
where
  total_facts =
    strictcount(ControlFlowNode f, Object value, ClassObject cls | depth = shallowest(f, value, cls)) and
  total_size =
    strictcount(ControlFlowNode f, Object value, ClassObject cls, PointsToContext ctx,
      ControlFlowNode orig |
      PointsTo::points_to(f, ctx, value, cls, orig) and
      depth = ctx.getDepth()
    ) and
  efficiency = 100.0 * total_facts / total_size
select depth, total_facts, total_size, efficiency
