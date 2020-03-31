/**
 * @name Cross-site scripting through exception
 * @description Inserting data from an exception containing user
 *              input into the DOM may enable cross-site scripting.
 * @kind path-problem
 * @problem.severity error
 * @precision medium
 * @id js/xss-through-exception
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript
import semmle.javascript.security.dataflow.ExceptionXss::ExceptionXss
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  sink.getNode().(Xss::Shared::Sink).getVulnerabilityKind() + " vulnerability due to $@.",
  source.getNode(), "user-provided value"
