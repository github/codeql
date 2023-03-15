/**
 * @name XPath injection
 * @description Building an XPath expression from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id java/xml/xpath-injection
 * @tags security
 *       external/cwe/cwe-643
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.XPath

private module XPathInjectionConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof XPathInjectionSink }
}

module XPathInjectionFlow = TaintTracking::Make<XPathInjectionConfiguration>;

import XPathInjectionFlow::PathGraph

from XPathInjectionFlow::PathNode source, XPathInjectionFlow::PathNode sink
where XPathInjectionFlow::hasFlowPath(source, sink)
select sink.getNode(), source, sink, "XPath expression depends on a $@.", source.getNode(),
  "user-provided value"
