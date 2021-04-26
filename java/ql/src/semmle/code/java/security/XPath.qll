import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.XmlParsers

/**
 * An abstract type representing a call to interpret XPath expressions.
 */
class XPathSink extends MethodAccess {
  abstract Expr getSink();
}

/** The class `javax.xml.xpath.XPath` */
class XPath extends RefType {
  XPath() { this.hasQualifiedName("javax.xml.xpath", "XPath") }
}

/** A call to `XPath.Evaluate` or `XPath.compile` */
class XPathEvaluateOrCompile extends XPathSink {
  XPathEvaluateOrCompile() {
    exists(Method m | this.getMethod() = m and m.getDeclaringType() instanceof XPath |
      m.hasName("evaluate")
      or
      m.hasName("compile")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }
}

/** The class `org.dom4j.Node` */
class Dom4JNode extends RefType {
  Dom4JNode() { this.hasQualifiedName("org.dom4j", "Node") }
}

/** A call to `Node.selectNodes` or `Node.selectSingleNode` */
class NodeSelectNodes extends XPathSink {
  NodeSelectNodes() {
    exists(Method m | this.getMethod() = m and m.getDeclaringType() instanceof Dom4JNode |
      m.hasName("selectNodes") or m.hasName("selectSingleNode")
    )
  }

  override Expr getSink() { result = this.getArgument(0) }
}

class XPathInjectionSink extends DataFlow::ExprNode {
  XPathInjectionSink() { exists(XPathSink sink | this.getExpr() = sink.getSink()) }
}

class XPathInjectionConfiguration extends TaintTracking::Configuration {
  XPathInjectionConfiguration() { this = "XPathInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XPathInjectionSink }
}
