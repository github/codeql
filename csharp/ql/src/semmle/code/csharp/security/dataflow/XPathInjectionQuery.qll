/**
 * Provides a taint-tracking configuration for reasoning about untrusted user input used in XPath expression.
 */

import csharp
private import semmle.code.csharp.security.dataflow.flowsources.Remote
private import semmle.code.csharp.frameworks.system.xml.XPath
private import semmle.code.csharp.frameworks.system.Xml
private import semmle.code.csharp.security.Sanitizers

/**
 * A data flow source for untrusted user input used in XPath expression.
 */
abstract class Source extends DataFlow::Node { }

/**
 * A data flow sink for untrusted user input used in XPath expression.
 */
abstract class Sink extends DataFlow::ExprNode { }

/**
 * A sanitizer for untrusted user input used in XPath expression.
 */
abstract class Sanitizer extends DataFlow::ExprNode { }

/**
 * A taint-tracking configuration for untrusted user input used in XPath expression.
 */
class TaintTrackingConfiguration extends TaintTracking::Configuration {
  TaintTrackingConfiguration() { this = "XPathInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}

/** A source of remote user input. */
class RemoteSource extends Source {
  RemoteSource() { this instanceof RemoteFlowSource }
}

/** The `xpath` argument to an `XPathExpression.Compile(..)` call. */
class XPathExpressionCompileSink extends Sink {
  XPathExpressionCompileSink() {
    this.getExpr() =
      any(SystemXmlXPath::XPathExpression xpathExpr)
          .getAMethod("Compile")
          .getACall()
          .getArgumentForName("xpath")
  }
}

/** The `xpath` argument to an `XmlNode.Select*Node*(..)` call. */
class XmlNodeSink extends Sink {
  XmlNodeSink() {
    this.getExpr() =
      any(SystemXmlXmlNodeClass xmlNode)
          .getASelectNodeMethod()
          .getACall()
          .getArgumentForName("xpath")
  }
}

/** The `xpath` argument to an `XPathNavigator` call. */
class XmlNavigatorSink extends Sink {
  XmlNavigatorSink() {
    exists(SystemXmlXPath::XPathNavigator xmlNav, Method m |
      this.getExpr() = m.getACall().getArgumentForName("xpath")
    |
      m = xmlNav.getASelectMethod() or
      m = xmlNav.getCompileMethod() or
      m = xmlNav.getAnEvaluateMethod() or
      m = xmlNav.getAMatchesMethod()
    )
  }
}

private class SimpleTypeSanitizer extends Sanitizer, SimpleTypeSanitizedExpr { }

private class GuidSanitizer extends Sanitizer, GuidSanitizedExpr { }
