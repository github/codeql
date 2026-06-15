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
import semmle.javascript.security.dataflow.DeepObjectResourceExhaustionQuery
import DataFlow::DeduplicatePathGraph<DeepObjectResourceExhaustionFlow::PathNode, DeepObjectResourceExhaustionFlow::PathGraph>

from PathNode source, PathNode sink, DataFlow::Node link, string reason
where
  DeepObjectResourceExhaustionFlow::flowPath(source.getAnOriginalPathNode(),
    sink.getAnOriginalPathNode()) and
  sink.getNode().(Sink).hasReason(link, reason)
select sink, source, sink, "Denial of service caused by processing $@ with $@.", source.getNode(),
  "user input", link, reason
