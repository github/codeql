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
import DataFlow::PathGraph
import semmle.javascript.security.dataflow.UnsafeHtmlConstructionQuery

from DataFlow::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, Sink sinkNode
where cfg.hasFlowPath(source, sink) and sink.getNode() = sinkNode
select sinkNode, source, sink, "$@ based on $@ might later cause $@.", sinkNode,
  sinkNode.describe(), source.getNode(), "library input", sinkNode.getSink(),
  sinkNode.getVulnerabilityKind().toLowerCase()
