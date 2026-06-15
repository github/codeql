/**
 * @name Resource exhaustion with additional heuristic sources
 * @description Allocating objects or timers with user-controlled
 *              sizes or durations can cause resource exhaustion.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @id js/resource-exhaustion-more-sources
 * @precision high
 * @tags experimental
 *       security
 *       external/cwe/cwe-400
 *       external/cwe/cwe-770
 */

import javascript
import semmle.javascript.security.dataflow.ResourceExhaustionQuery
import semmle.javascript.heuristics.AdditionalSources
import ResourceExhaustionFlow::PathGraph

from ResourceExhaustionFlow::PathNode source, ResourceExhaustionFlow::PathNode sink
where ResourceExhaustionFlow::flowPath(source, sink) and source.getNode() instanceof HeuristicSource
select sink, source, sink, sink.getNode().(Sink).getProblemDescription() + " from a $@.", source,
  "user-provided value"
