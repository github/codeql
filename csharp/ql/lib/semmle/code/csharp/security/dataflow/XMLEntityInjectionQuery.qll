/**
 * Provides a taint-tracking configuration for reasoning about untrusted user input used in XML processing
 */

import csharp
private import semmle.code.csharp.security.dataflow.flowsinks.FlowSinks
private import semmle.code.csharp.security.dataflow.flowsources.FlowSources
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.text.RegularExpressions
private import semmle.code.csharp.security.xml.InsecureXMLQuery as InsecureXml
private import semmle.code.csharp.security.Sanitizers

/**
 * A data flow source for untrusted user input used in XML processing.
 */
abstract class Source extends DataFlow::Node { }

private class ThreatModelSource extends Source instanceof ActiveThreatModelSource { }

/**
 * A data flow sink for untrusted user input used in XML processing.
 */
abstract class Sink extends ApiSinkExprNode {
  /**
   * Gets the reason for the insecurity of this sink.
   */
  abstract string getReason();
}

private class InsecureXmlSink extends Sink {
  private string reason;

  InsecureXmlSink() {
    exists(InsecureXml::InsecureXmlProcessing r | r.isUnsafe(reason) |
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
private module XmlEntityInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * A taint-tracking module for untrusted user input used in XML processing.
 */
module XmlEntityInjection implements DataFlow::GlobalFlowSig {
  import TaintTracking::Global<XmlEntityInjectionConfig> as Super
  import Super

  /**
   * Holds if data can flow from `source` to `sink`.
   *
   * The corresponding paths are generated from the end-points and the graph
   * included in the module `PathGraph`.
   */
  predicate flowPath(XmlEntityInjection::PathNode source, XmlEntityInjection::PathNode sink) {
    Super::flowPath(source, sink) and
    exists(sink.getNode().(Sink).getReason())
  }
}

private class SimpleTypeSanitizer extends Sanitizer, SimpleTypeSanitizedExpr { }

private class GuidSanitizer extends Sanitizer, GuidSanitizedExpr { }
