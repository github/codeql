/**
 * Provides a taint-tracking configuration for reasoning about untrusted user input used in XML processing
 */

import csharp

module XMLEntityInjection {
  import semmle.code.csharp.dataflow.flowsources.Remote
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
    InsecureXMLSink() {
      // Unfortunately, we cannot use
      // ```
      // exists(InsecureXML::InsecureXmlProcessing r | r.isUnsafe(reason) | this = r.getAnArgument())
      // ```
      // in the charpred, as that results in bad aggregate
      // recursion. Therefore, we overestimate the sinks here
      // and make the restriction later by overriding
      // `hasFlowPath()` below.
      this.getExpr() = any(MethodCall mc |
          mc.getTarget().hasQualifiedName("System.Xml.XmlReader.Create") or
          mc.getTarget().hasQualifiedName("System.Xml.XmlDocument.Load") or
          mc.getTarget().hasQualifiedName("System.Xml.XmlDocument.LoadXml")
        ).getAnArgument()
      or
      this.getExpr() = any(ObjectCreation oc |
          oc.getObjectType().(ValueOrRefType).hasQualifiedName("System.Xml.XmlTextReader")
        ).getAnArgument()
    }

    override string getReason() {
      exists(InsecureXML::InsecureXmlProcessing r | r.isUnsafe(result) |
        this.getExpr() = r.getAnArgument()
      )
    }
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
