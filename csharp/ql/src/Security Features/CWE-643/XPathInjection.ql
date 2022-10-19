/**
 * @name XPath injection
 * @description Building an XPath expression from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id cs/xml/xpath-injection
 * @tags security
 *       external/cwe/cwe-643
 */

import csharp
import semmle.code.csharp.security.dataflow.XPathInjectionQuery
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

from TaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This XPath expression depends on a $@.", source.getNode(),
  "user-provided value"
