/**
 * @name Stored XPath injection
 * @description Building an XPath expression from stored data which may have been provided by the
 *              user is vulnerable to insertion of malicious code by the user.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cs/xml/stored-xpath-injection
 * @tags security
 *       external/cwe/cwe-643
 */
import csharp
import semmle.code.csharp.security.dataflow.flowsources.Stored
import semmle.code.csharp.security.dataflow.XPathInjection

class StoredTaintTrackingConfiguration extends XPathInjection::TaintTrackingConfiguration {
  override
  predicate isSource(DataFlow::Node source) {
    source instanceof StoredFlowSource
  }
}

from StoredTaintTrackingConfiguration c, DataFlow::Node source, DataFlow::Node sink
where c.hasFlow(source, sink)
select sink, "$@ flows to here and is used in an XPath expression.", source, "Stored user-provided value"
