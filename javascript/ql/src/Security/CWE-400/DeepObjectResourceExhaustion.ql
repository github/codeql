/**
 * @name Resources exhaustion from deep object traversal
 * @description Processing user-controlled object hierarchies inefficiently can lead to denial of service.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id js/resource-exhaustion-from-deep-object-traversal
 * @tags security
 *       external/cwe/cwe-400
 */

import javascript
import DataFlow::PathGraph
import semmle.javascript.security.dataflow.DeepObjectResourceExhaustionQuery

from
  Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, DataFlow::Node link,
  string reason
where
  cfg.hasFlowPath(source, sink) and
  sink.getNode().(Sink).hasReason(link, reason)
select sink, source, sink, "Denial of service caused by processing user input from $@ with $@.",
  source.getNode(), "here", link, reason
