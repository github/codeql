/**
 * Provides a taint-tracking configuration for reasoning about untrusted user input used in XML processing
 */

import csharp

module XMLEntityInjection {
  import semmle.code.csharp.security.dataflow.flowsources.Remote
  import semmle.code.csharp.frameworks.System
  import semmle.code.csharp.frameworks.system.text.RegularExpressions
  import semmle.code.csharp.security.xml.InsecureXML
  import semmle.code.csharp.security.Sanitizers

  /**
   * A data flow source for untrusted user input used in XML processing.
   */
  abstract class Source extends DataFlow::Node { }

  class RemoteSource extends Source {
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

  class InsecureXMLSink extends Sink {
    private string reason;

    InsecureXMLSink() {
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
}
