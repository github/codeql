/**
 * @name XPath injection
 * @description Building an XPath expression from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/xpath-injection
 * @tags security
 *       external/cwe/cwe-643
 */

import javascript
import semmle.javascript.security.dataflow.XpathInjection::XpathInjection
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows here and is used in an XPath expression.",
  source.getNode(), "User-provided value"
