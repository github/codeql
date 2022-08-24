/**
 * @name Call graph
 * @description An edge in the call graph.
 * @kind problem
 * @problem.severity recommendation
 * @id py/meta/call-graph
 * @tags meta
 * @precision very-low
 */

import python
import semmle.python.dataflow.new.internal.DataFlowPrivate

from DataFlowCall call, DataFlowCallable target
where target = viableCallable(call)
select call, "Call to $@", target.getScope(), target.toString()
