/**
 * Compute the efficiency of the points-to relation. That is the ratio of
 *     "interesting" facts to total facts.
 */

import python
import semmle.python.pointsto.PointsTo
import semmle.python.pointsto.PointsToContext

predicate trivial(ControlFlowNode f) {
  exists(Parameter p | p = f.getNode())
  or
  f instanceof NameConstantNode
  or
  f.getNode() instanceof ImmutableLiteral
}

from int interesting_facts, int interesting_facts_in_source, int total_size, float efficiency
where
  interesting_facts =
    strictcount(ControlFlowNode f, Object value, ClassObject cls |
      f.refersTo(value, cls, _) and not trivial(f)
    ) and
  interesting_facts_in_source =
    strictcount(ControlFlowNode f, Object value, ClassObject cls |
      f.refersTo(value, cls, _) and
      not trivial(f) and
      exists(f.getScope().getEnclosingModule().getFile().getRelativePath())
    ) and
  total_size =
    strictcount(ControlFlowNode f, PointsToContext ctx, Object value, ClassObject cls,
      ControlFlowNode orig | PointsTo::points_to(f, ctx, value, cls, orig)) and
  efficiency = 100.0 * interesting_facts_in_source / total_size
select interesting_facts, interesting_facts_in_source, total_size, efficiency
