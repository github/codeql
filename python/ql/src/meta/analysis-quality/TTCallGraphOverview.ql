/**
 * @name Call graph edge overview from using type-tracking instead of points-to
 * @id py/meta/call-graph-overview
 * @precision very-low
 */

import python
import CallGraphQuality

from string tag, int c
where
  tag = "SHARED" and
  c =
    count(CallNode call, Target target |
      target.isRelevant() and
      call.(PointsToBasedCallGraph::ResolvableCall).getTarget() = target and
      call.(TypeTrackingBasedCallGraph::ResolvableCall).getTarget() = target
    )
  or
  tag = "NEW" and
  c =
    count(CallNode call, Target target |
      target.isRelevant() and
      not call.(PointsToBasedCallGraph::ResolvableCall).getTarget() = target and
      call.(TypeTrackingBasedCallGraph::ResolvableCall).getTarget() = target
    )
  or
  tag = "MISSING" and
  c =
    count(CallNode call, Target target |
      target.isRelevant() and
      call.(PointsToBasedCallGraph::ResolvableCall).getTarget() = target and
      not call.(TypeTrackingBasedCallGraph::ResolvableCall).getTarget() = target
    )
select tag, c
