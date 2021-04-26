/** Provides classes to reason about XPath vulnerabilities. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking

/**
 * An abstract type representing a call to interpret XPath expressions.
 */
class XPathSink extends MethodAccess {
  /**
   * Gets the argument representing the XPath expressions to be evaluated.
   */
  abstract Expr getSink();
}

/** The class `javax.xml.xpath.XPath` */
class XPath extends RefType {
  XPath() { this.hasQualifiedName("javax.xml.xpath", "XPath") }
}

/** A call to `XPath.evaluate` or `XPath.compile` */
class XPathEvaluateOrCompile extends XPathSink {
  XPathEvaluateOrCompile() {
    exists(Method m | this.getMethod() = m and m.getDeclaringType() instanceof XPath |
      m.hasName(["evaluate", "compile"])
    )
  }

  override Expr getSink() { result = this.getArgument(0) }
}

/** Any class extending or implementing `org.dom4j.Node` */
class Dom4JNode extends RefType {
  Dom4JNode() {
    exists(Interface node | node.hasQualifiedName("org.dom4j", "Node") |
      this.extendsOrImplements*(node)
    )
  }
}

/** A call to `Node.selectNodes` or `Node.selectSingleNode` */
class NodeSelectNodes extends XPathSink {
  NodeSelectNodes() {
    exists(Method m | this.getMethod() = m and m.getDeclaringType() instanceof Dom4JNode |
      m.hasName(["selectNodes", "selectSingleNode"])
    )
  }

  override Expr getSink() { result = this.getArgument(0) }
}

/** A sink that represents a method that interprets XPath expressions. */
class XPathInjectionSink extends DataFlow::ExprNode {
  XPathInjectionSink() { exists(XPathSink sink | this.getExpr() = sink.getSink()) }
}

/** A configuration that tracks data from a remote input source to a XPath evaluation sink. */
class XPathInjectionConfiguration extends TaintTracking::Configuration {
  XPathInjectionConfiguration() { this = "XPathInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XPathInjectionSink }
}
