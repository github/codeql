/** Provides classes to reason about XPath vulnerabilities. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow

/**
 * A sink that represents a method that interprets XPath expressions.
 * Extend this class to add your own XPath Injection sinks.
 */
abstract class XPathInjectionSink extends DataFlow::Node { }

/** CSV sink models representing methods susceptible to XPath Injection attacks. */
private class DefaultXPathInjectionSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.xml.xpath;XPath;true;evaluate;;;Argument[0];xpath",
        "javax.xml.xpath;XPath;true;evaluateExpression;;;Argument[0];xpath",
        "javax.xml.xpath;XPath;true;compile;;;Argument[0];xpath",
        "org.dom4j;Node;true;selectObject;;;Argument[0];xpath",
        "org.dom4j;Node;true;selectNodes;;;Argument[0..1];xpath",
        "org.dom4j;Node;true;selectSingleNode;;;Argument[0];xpath",
        "org.dom4j;Node;true;numberValueOf;;;Argument[0];xpath",
        "org.dom4j;Node;true;valueOf;;;Argument[0];xpath",
        "org.dom4j;Node;true;matches;;;Argument[0];xpath",
        "org.dom4j;Node;true;createXPath;;;Argument[0];xpath",
        "org.dom4j;DocumentFactory;true;createPattern;;;Argument[0];xpath",
        "org.dom4j;DocumentFactory;true;createXPath;;;Argument[0];xpath",
        "org.dom4j;DocumentFactory;true;createXPathFilter;;;Argument[0];xpath",
        "org.dom4j;DocumentHelper;false;createPattern;;;Argument[0];xpath",
        "org.dom4j;DocumentHelper;false;createXPath;;;Argument[0];xpath",
        "org.dom4j;DocumentHelper;false;createXPathFilter;;;Argument[0];xpath",
        "org.dom4j;DocumentHelper;false;selectNodes;;;Argument[0];xpath",
        "org.dom4j;DocumentHelper;false;sort;;;Argument[1];xpath",
        "org.dom4j.tree;AbstractNode;true;createXPathFilter;;;Argument[0];xpath",
        "org.dom4j.tree;AbstractNode;true;createPattern;;;Argument[0];xpath",
        "org.dom4j.util;ProxyDocumentFactory;true;createPattern;;;Argument[0];xpath",
        "org.dom4j.util;ProxyDocumentFactory;true;createXPath;;;Argument[0];xpath",
        "org.dom4j.util;ProxyDocumentFactory;true;createXPathFilter;;;Argument[0];xpath"
      ]
  }
}

/** A default sink representing methods susceptible to XPath Injection attacks. */
private class DefaultXPathInjectionSink extends XPathInjectionSink {
  DefaultXPathInjectionSink() {
    sinkNode(this, "xpath")
    or
    exists(ClassInstanceExpr constructor |
      constructor.getConstructedType().getASourceSupertype*().hasQualifiedName("org.dom4j", "XPath")
      or
      constructor.getConstructedType().hasQualifiedName("org.dom4j.xpath", "XPathPattern")
    |
      this.asExpr() = constructor.getArgument(0)
    )
  }
}
