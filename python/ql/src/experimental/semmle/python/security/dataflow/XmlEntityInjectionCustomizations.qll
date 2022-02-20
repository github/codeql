/**
 * Provides default sources, sinks and sanitizers for detecting
 * "ldap injection"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import experimental.semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards
private import semmle.python.ApiGraphs

/**
 * Provides default sources, sinks and sanitizers for detecting "xml injection"
 * vulnerabilities, as well as extension points for adding your own.
 */
module XmlEntityInjection {
  /**
   * A data flow source for "xml injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "xml injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer guard for "xml injection" vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A unit class for adding additional taint steps.
   *
   * Extend this class to add additional taint steps that should apply to `XmlEntityInjection`
   * taint configuration.
   */
  class AdditionalTaintStep extends Unit {
    /**
     * Holds if the step from `nodeFrom` to `nodeTo` should be considered a taint
     * step for `XmlEntityInjection` configuration.
     */
    abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
  }

  /**
   * A data flow sink for XML parsing libraries.
   *
   * See `XML::XMLParsing`.
   */
  abstract class XMLParsingSink extends Sink { }

  /**
   * A data flow sink for XML parsers.
   *
   * See `XML::XMLParser`
   */
  abstract class XMLParserSink extends Sink { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * An xml parsing operation, considered as a flow sink.
   */
  class XMLParsingInputAsSink extends XMLParsingSink {
    XMLParsingInputAsSink() { this = any(XML::XMLParsing xmlParsing).getAnInput() }
  }

  /**
   * An xml parsing operation vulnerable to `kind`.
   */
  predicate xmlParsingInputAsVulnerableSink(DataFlow::Node sink, string kind) {
    exists(XML::XMLParsing xmlParsing |
      sink = xmlParsing.getAnInput() and xmlParsing.vulnerable(kind)
    )
  }

  /**
   * An xml parser operation, considered as a flow sink.
   */
  class XMLParserInputAsSink extends XMLParserSink {
    XMLParserInputAsSink() { this = any(XML::XMLParser xmlParser).getAnInput() }
  }

  /**
   * An xml parser operation vulnerable to `kind`.
   */
  predicate xmlParserInputAsVulnerableSink(DataFlow::Node sink, string kind) {
    exists(XML::XMLParser xmlParser | sink = xmlParser.getAnInput() and xmlParser.vulnerable(kind))
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsSanitizerGuard extends SanitizerGuard, StringConstCompare { }

  /**
   * A taint step for `io`'s `StringIO` and `BytesIO` methods.
   */
  class IoAdditionalTaintStep extends AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(DataFlow::CallCfgNode ioCalls |
        ioCalls = API::moduleImport("io").getMember(["StringIO", "BytesIO"]).getACall() and
        nodeFrom = ioCalls.getArg(0) and
        nodeTo = ioCalls
      )
    }
  }
}
