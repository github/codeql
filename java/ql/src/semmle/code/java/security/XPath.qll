/** Provides classes to reason about XPath vulnerabilities. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking

/** The class `javax.xml.xpath.XPath` */
private class XPath extends RefType {
  XPath() { this.hasQualifiedName("javax.xml.xpath", "XPath") }
}

/** A call to `XPath.evaluate` or `XPath.compile` */
private class XPathEvaluateOrCompile extends MethodAccess {
  XPathEvaluateOrCompile() {
    exists(Method m |
      this.getMethod() = m and m.getDeclaringType() instanceof XPath
    |
      m.hasName(["evaluate", "compile"])
    )
  }
}

/** The interface `org.dom4j.Node` */
private class Dom4JNode extends Interface {
  Dom4JNode() { this.hasQualifiedName("org.dom4j", "Node") }
}

/** A call to `Node.selectNodes` or `Node.selectSingleNode` */
private class NodeSelectNodes extends MethodAccess {
  NodeSelectNodes() {
    exists(Method m |
      this.getMethod() = m and m.getDeclaringType().getASourceSupertype*() instanceof Dom4JNode
    |
      m.hasName(["selectNodes", "selectSingleNode"])
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
    exists(NodeSelectNodes sink | sink.getArgument(0) = this.asExpr()) or
    exists(XPathEvaluateOrCompile sink | sink.getArgument(0) = this.asExpr())
  }
}
