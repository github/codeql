/** Provides classes to reason about XPath vulnerabilities. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking

/** The interface `javax.xml.xpath.XPath` */
private class XPath extends Interface {
  XPath() { this.hasQualifiedName("javax.xml.xpath", "XPath") }
}

/** A call to methods of any class implementing the interface `XPath` that evaluate XPath expressions */
private class XPathEvaluation extends MethodAccess {
  XPathEvaluation() {
    exists(Method m |
      this.getMethod() = m and m.getDeclaringType().getASourceSupertype*() instanceof XPath
    |
      m.hasName(["evaluate", "evaluateExpression", "compile"])
    )
  }
}

/** The interface `org.dom4j.Node` */
private class Dom4JNode extends Interface {
  Dom4JNode() { this.hasQualifiedName("org.dom4j", "Node") }
}

/** A call to methods of any class implementing the interface `Node` that evaluate XPath expressions */
private class NodeXPathEvaluation extends MethodAccess {
  NodeXPathEvaluation() {
    exists(Method m |
      this.getMethod() = m and m.getDeclaringType().getASourceSupertype*() instanceof Dom4JNode
    |
      m.hasName([
          "selectObject", "selectNodes", "selectSingleNode", "numberValueOf", "valueOf", "matches",
          "createXPath"
        ])
    )
  }
}

/**
 *  A sink that represents a method that interprets XPath expressions.
 *  Extend this class to add your own XPath Injection sinks.
 */
abstract class XPathInjectionSink extends DataFlow::Node { }

private class DefaultXPathInjectionSink extends XPathInjectionSink {
  DefaultXPathInjectionSink() {
    exists(NodeXPathEvaluation sink | sink.getArgument(0) = this.asExpr()) or
    exists(XPathEvaluation sink | sink.getArgument(0) = this.asExpr())
  }
}
