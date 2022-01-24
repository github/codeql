/**
 * @name Stored XPath injection
 * @description Building an XPath expression from stored data which may have been provided by the
 *              user is vulnerable to insertion of malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision medium
 * @id cs/xml/stored-xpath-injection
 * @tags security
 *       external/cwe/cwe-643
 */

import csharp
import semmle.code.csharp.security.dataflow.flowsources.Stored
import semmle.code.csharp.security.dataflow.XPathInjectionQuery as XPathInjection
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

class StoredTaintTrackingConfiguration extends XPathInjection::TaintTrackingConfiguration {
  override predicate isSource(DataFlow::Node source) { source instanceof StoredFlowSource }
}

from StoredTaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to here and is used in an XPath expression.",
  source.getNode(), "Stored user-provided value"
