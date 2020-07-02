/**
 * @name DOM text reinterpreted as HTML
 * @description Reinterpreting text from the DOM as HTML
 *              can lead to a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
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
select sink.getNode(), source, sink,
  "$@ is reinterpreted as HTML without escaping meta-characters.", source.getNode(), "DOM text"
