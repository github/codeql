/**
 * @name Resource exhaustion
 * @description Allocating objects or timers with user-controlled
 *              sizes or durations can cause resource exhaustion.
 * @kind path-problem
 * @problem.severity warning
 * @id js/resource-exhaustion
 * @precision high
 * @tags security
 *       external/cwe/cwe-770
 */

import javascript
import DataFlow::PathGraph
import semmle.javascript.security.dataflow.ResourceExhaustion::ResourceExhaustion

from Configuration dataflow, DataFlow::PathNode source, DataFlow::PathNode sink
where dataflow.hasFlowPath(source, sink)
select sink, source, sink, sink.getNode().(Sink).getProblemDescription() + " from $@.", source,
  "here"
