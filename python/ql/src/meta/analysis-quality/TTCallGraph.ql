/**
 * @name New call graph edge from using type-tracking instead of points-to
 * @kind problem
 * @problem.severity recommendation
 * @id py/meta/type-tracking-call-graph
 * @precision very-low
 */

import python
import CallGraphQuality

from CallNode call, Target target
where
  target.isRelevant() and
  call.(TypeTrackingBasedCallGraph::ResolvableCall).getTarget() = target
select call, "$@ to $@", call, "Call", target, target.toString()
