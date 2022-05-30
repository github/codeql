/**
 * @name New arg->param edge from using type-tracking instead of points-to
 * @kind problem
 * @problem.severity recommendation
 * @id py/meta/arg-passing-new
 * @tags meta
 * @precision very-low
 */

import python
import ArgumentPassing

from ControlFlowNode arg, Parameter param
where
  not PointsToArgumentPassing::argumentPassing(arg, param) and
  TypeTrackingArgumentPassing::argumentPassing(arg, param)
select arg, "NEW: $@ flow to $@", arg, "Argument", param, param.toString()
