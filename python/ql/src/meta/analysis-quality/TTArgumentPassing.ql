/**
 * @name arg->param edge from using type-tracking
 * @kind problem
 * @problem.severity recommendation
 * @id py/meta/arg-passing
 * @tags meta
 * @precision very-low
 */

import python
import ArgumentPassing

from ControlFlowNode arg, Parameter param
where TypeTrackingArgumentPassing::argumentPassing(arg, param)
select arg, "$@ flow to $@", arg, "Argument", param, param.toString()
