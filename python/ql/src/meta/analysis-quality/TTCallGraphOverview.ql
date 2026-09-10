/**
 * @name Call graph edge overview from using type-tracking instead of points-to
 * @id py/meta/call-graph-overview
 * @precision very-low
 */

import python
import CallGraphQuality
private import semmle.python.controlflow.internal.Cfg as Cfg

from string tag, int c
where
  tag = "SHARED" and
  c =
    count(Cfg::CallNode call, Target target |
      target.isRelevant() and
      call.(PointsToBasedCallGraph::ResolvableCall).getTarget() = target and
      call.(TypeTrackingBasedCallGraph::ResolvableCall).getTarget() = target
    )
  or
  tag = "NEW" and
  c =
    count(Cfg::CallNode call, Target target |
      target.isRelevant() and
      not call.(PointsToBasedCallGraph::ResolvableCall).getTarget() = target and
      call.(TypeTrackingBasedCallGraph::ResolvableCall).getTarget() = target
    )
  or
  tag = "MISSING" and
  c =
    count(Cfg::CallNode call, Target target |
      target.isRelevant() and
      call.(PointsToBasedCallGraph::ResolvableCall).getTarget() = target and
      not call.(TypeTrackingBasedCallGraph::ResolvableCall).getTarget() = target
    )
select tag, c
