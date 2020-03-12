/**
 * @name XPath injection
 * @description Building an XPath expression from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/xml/xpath-injection
 * @tags security
 *       external/cwe/cwe-643
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.XmlParsers
import DataFlow::PathGraph

class XPathInjectionConfiguration extends TaintTracking::Configuration {
  XPathInjectionConfiguration() { this = "XPathInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XPathInjectionSink }
}

class XPathInjectionSink extends DataFlow::ExprNode {
  XPathInjectionSink() {
    exists(Method m, MethodAccess ma | ma.getMethod() = m |
      m.getDeclaringType().hasQualifiedName("javax.xml.xpath", "XPath") and
      (m.hasName("evaluate") or m.hasName("compile")) and
      ma.getArgument(0) = this.getExpr()
      or
      m.getDeclaringType().hasQualifiedName("org.dom4j", "Node") and
      (m.hasName("selectNodes") or m.hasName("selectSingleNode")) and
      ma.getArgument(0) = this.getExpr()
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, XPathInjectionConfiguration c
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to here and is used in an XPath expression.",
  source.getNode(), "User-provided value"
