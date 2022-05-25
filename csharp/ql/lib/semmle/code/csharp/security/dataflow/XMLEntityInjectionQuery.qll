/**
 * Provides a taint-tracking configuration for reasoning about untrusted user input used in XML processing
 */

import csharp
private import semmle.code.csharp.security.dataflow.flowsources.Remote
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.text.RegularExpressions
private import semmle.code.csharp.security.xml.InsecureXMLQuery as InsecureXML
private import semmle.code.csharp.security.Sanitizers

/**
 * A data flow source for untrusted user input used in XML processing.
 */
abstract class Source extends DataFlow::Node { }

private class RemoteSource extends Source {
  RemoteSource() { this instanceof RemoteFlowSource }
}

/**
 * A data flow sink for untrusted user input used in XML processing.
 */
abstract class Sink extends DataFlow::ExprNode {
  /**
   * Gets the reason for the insecurity of this sink.
   */
  abstract string getReason();
}

private class InsecureXmlSink extends Sink {
  private string reason;

  InsecureXmlSink() {
    exists(InsecureXML::InsecureXmlProcessing r | r.isUnsafe(reason) |
      this.getExpr() = r.getAnArgument()
    )
  }

  override string getReason() { result = reason }
}

/**
 * A sanitizer for untrusted user input used in XML processing.
 */
abstract class Sanitizer extends DataFlow::Node { }

/**
 * A taint-tracking configuration for untrusted user input used in XML processing.
 */
class TaintTrackingConfiguration extends TaintTracking::Configuration {
  TaintTrackingConfiguration() { this = "XMLInjection" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

  override predicate hasFlowPath(DataFlow::PathNode source, DataFlow::PathNode sink) {
    super.hasFlowPath(source, sink) and
    exists(sink.getNode().(Sink).getReason())
  }
}

private class SimpleTypeSanitizer extends Sanitizer, SimpleTypeSanitizedExpr { }

private class GuidSanitizer extends Sanitizer, GuidSanitizedExpr { }
