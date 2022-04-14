/**
 * @name Resource exhaustion
 * @description Allocating objects or timers with user-controlled
 *              sizes or durations can cause resource exhaustion.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @id js/resource-exhaustion
 * @precision high
 * @tags security
 *       external/cwe/cwe-400
 *       external/cwe/cwe-770
 */

import javascript
import DataFlow::PathGraph
import semmle.javascript.security.dataflow.ResourceExhaustionQuery

from Configuration dataflow, DataFlow::PathNode source, DataFlow::PathNode sink
where dataflow.hasFlowPath(source, sink)
select sink, source, sink, sink.getNode().(Sink).getProblemDescription() + " from $@.", source,
  "here"
