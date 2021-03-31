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
private import semmle.code.java.dataflow.ExternalFlow

class XPathInjectionConfiguration extends TaintTracking::Configuration {
  XPathInjectionConfiguration() { this = "XPathInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XPathInjectionSink }
}

class XPathInjectionSink extends DataFlow::ExprNode {
  XPathInjectionSink() { sinkNode(this, "xpath") }
}

private class XPathInjectionSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.xml.xpath;XPath;false;compile;;;Argument[0];xpath",
        "javax.xml.xpath;XPath;false;evaluate;;;Argument[0];xpath",
        "org.dom4j;Node;false;selectNodes;;;Argument[0];xpath",
        "org.dom4j;Node;false;selectSingleNode;;;Argument[0];xpath"
      ]
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, XPathInjectionConfiguration c
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to here and is used in an XPath expression.",
  source.getNode(), "User-provided value"
