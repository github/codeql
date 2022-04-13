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
  abstract class Sink extends DataFlow::Node {
    /** Gets the kind of XML injection that this sink is vulnerable to. */
    abstract string getVulnerableKind();
  }

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
   * An input to a direct XML parsing function, considered as a flow sink.
   *
   * See `XML::XMLParsing`.
   */
  class XMLParsingInputAsSink extends Sink {
    ExperimentalXML::XMLParsing xmlParsing;

    XMLParsingInputAsSink() { this = xmlParsing.getAnInput() }

    override string getVulnerableKind() { xmlParsing.vulnerableTo(result) }
  }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

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
