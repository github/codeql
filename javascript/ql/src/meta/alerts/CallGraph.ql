/**
 * @name Call graph
 * @description An edge in the call graph.
 * @kind problem
 * @problem.severity recommendation
 * @id js/meta/alerts/call-graph
 * @tags meta
 * @precision very-low
 */

import javascript

from DataFlow::Node invoke, Function f, string kind
where
  invoke.(DataFlow::InvokeNode).getACallee() = f and kind = "Call"
  or
  invoke.(DataFlow::PropRef).getAnAccessorCallee().getFunction() = f and kind = "Accessor call"
select invoke, kind + " to $@", f, f.describe()
