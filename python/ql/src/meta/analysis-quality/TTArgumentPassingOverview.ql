/**
 * @name arg->param edge from using type-tracking vs. points-to
 * @id py/meta/arg-passing-overview
 */

import python
import ArgumentPassing

from string tag, int c
where
  tag = "SHARED" and
  c =
    count(ControlFlowNode arg, Parameter param |
      PointsToArgumentPassing::argumentPassing(arg, param) and
      TypeTrackingArgumentPassing::argumentPassing(arg, param)
    )
  or
  tag = "NEW" and
  c =
    count(ControlFlowNode arg, Parameter param |
      not PointsToArgumentPassing::argumentPassing(arg, param) and
      TypeTrackingArgumentPassing::argumentPassing(arg, param)
    )
  or
  tag = "MISSING" and
  c =
    count(ControlFlowNode arg, Parameter param |
      PointsToArgumentPassing::argumentPassing(arg, param) and
      not TypeTrackingArgumentPassing::argumentPassing(arg, param)
    )
select tag, c
