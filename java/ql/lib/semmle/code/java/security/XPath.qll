/** Provides classes to reason about XPath vulnerabilities. */

import java
import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSinks

/**
 * A sink that represents a method that interprets XPath expressions.
 * Extend this class to add your own XPath Injection sinks.
 */
abstract class XPathInjectionSink extends ApiSinkNode { }

/** A default sink representing methods susceptible to XPath Injection attacks. */
private class DefaultXPathInjectionSink extends XPathInjectionSink {
  DefaultXPathInjectionSink() {
    sinkNode(this, "xpath-injection")
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
