/**
 * @name Client-side cross-site scripting
 * @description Writing user input directly to the DOM allows for
 *              a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision high
 * @id js/xss
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript
import semmle.javascript.security.dataflow.DomBasedXssQuery
import DataFlow::PathGraph

from DataFlow::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  sink.getNode().(Sink).getVulnerabilityKind() + " vulnerability due to $@.", source.getNode(),
  "user-provided value"
