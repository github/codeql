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
import semmle.code.csharp.security.dataflow.XPathInjectionQuery
import StoredXpathInjection::PathGraph

module StoredXpathInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof StoredFlowSource }

  predicate isSink = XpathInjectionConfig::isSink/1;

  predicate isBarrier = XpathInjectionConfig::isBarrier/1;
}

module StoredXpathInjection = TaintTracking::Global<StoredXpathInjectionConfig>;

from StoredXpathInjection::PathNode source, StoredXpathInjection::PathNode sink
where StoredXpathInjection::flowPath(source, sink)
select sink.getNode(), source, sink, "This XPath expression depends on a $@.", source.getNode(),
  "stored (potentially user-provided) value"
