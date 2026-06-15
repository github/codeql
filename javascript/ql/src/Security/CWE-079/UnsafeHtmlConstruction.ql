/**
 * @name Unsafe HTML constructed from library input
 * @description Using externally controlled strings to construct HTML might allow a malicious
 *              user to perform a cross-site scripting attack.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision high
 * @id js/html-constructed-from-input
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript
import semmle.javascript.security.dataflow.UnsafeHtmlConstructionQuery
import DataFlow::DeduplicatePathGraph<UnsafeHtmlConstructionFlow::PathNode, UnsafeHtmlConstructionFlow::PathGraph>

from PathNode source, PathNode sink, Sink sinkNode
where
  UnsafeHtmlConstructionFlow::flowPath(source.getAnOriginalPathNode(), sink.getAnOriginalPathNode()) and
  sink.getNode() = sinkNode
select sinkNode, source, sink,
  "This " + sinkNode.describe() + " which depends on $@ might later allow $@.", source.getNode(),
  "library input", sinkNode.getSink(), sinkNode.getVulnerabilityKind().toLowerCase()
