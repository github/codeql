/**
 * @name XPath injection
 * @description Building an XPath expression from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @id go/xml/xpath-injection
 * @tags security
 *       external/cwe/cwe-643
 */

import go
import semmle.go.security.XPathInjection::XPathInjection
import DataFlow::PathGraph

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows here and is used in an XPath expression.",
  source.getNode(), "A user-provided value"
