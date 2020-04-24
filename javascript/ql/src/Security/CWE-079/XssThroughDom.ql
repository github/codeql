/**
 * @name Cross-site scripting through DOM
 * @description Writing user-controlled DOM to HTML can allow for
 *              a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @precision medium
 * @id js/xss-through-dom
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript
import semmle.javascript.security.dataflow.XssThroughDom::XssThroughDom
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Cross-site scripting vulnerability due to $@.",
  source.getNode(), "DOM text"
