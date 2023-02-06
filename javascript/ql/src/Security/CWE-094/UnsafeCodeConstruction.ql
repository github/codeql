/**
 * @name Unsafe code constructed from library input
 * @description Using externally controlled strings to construct code may allow a malicious
 *              user to execute arbitrary code.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.1
 * @precision medium
 * @id js/unsafe-code-construction
 * @tags security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript
import DataFlow::PathGraph
import semmle.javascript.security.dataflow.UnsafeCodeConstruction::UnsafeCodeConstruction

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, Sink sinkNode
where cfg.hasFlowPath(source, sink) and sinkNode = sink.getNode()
select sink.getNode(), source, sink,
  "This " + sinkNode.getSinkType() + " which depends on $@ is later $@.", source.getNode(),
  "library input", sinkNode.getCodeSink(), "interpreted as code"
