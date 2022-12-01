/**
 * @name Call graph
 * @description An edge in the points-to call graph.
 * @kind problem
 * @problem.severity recommendation
 * @id py/meta/points-to-call-graph
 * @tags meta
 * @precision very-low
 */

import python
import semmle.python.dataflow.new.internal.DataFlowPrivate
import meta.MetaMetrics

from DataFlowCall c, DataFlowCallableValue f
where
  c.getCallable() = f and
  not c.getLocation().getFile() instanceof IgnoredFile and
  not f.getScope().getLocation().getFile() instanceof IgnoredFile
select c, "Call to $@", f.getScope(), f.toString()
