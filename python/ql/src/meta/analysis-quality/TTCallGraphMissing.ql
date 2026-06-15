/**
 * @name Missing call graph edge from using type-tracking instead of points-to
 * @kind problem
 * @problem.severity recommendation
 * @id py/meta/call-graph-missing
 * @precision very-low
 */

import python
import CallGraphQuality

from CallNode call, Target target
where
  target.isRelevant() and
  call.(PointsToBasedCallGraph::ResolvableCall).getTarget() = target and
  not call.(TypeTrackingBasedCallGraph::ResolvableCall).getTarget() = target
select call, "MISSING: $@ to $@", call, "Call", target, target.toString()
