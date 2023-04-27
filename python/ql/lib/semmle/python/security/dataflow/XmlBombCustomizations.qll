/**
 * Provides default sources, sinks and sanitizers for detecting
 * "XML bomb"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources

/**
 * Provides default sources, sinks and sanitizers for detecting "XML bomb"
 * vulnerabilities, as well as extension points for adding your own.
 */
module XmlBomb {
  /**
   * A data flow source for XML-bomb vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for XML-bomb vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for XML-bomb vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A source of remote user input, considered as a flow source for XML bomb vulnerabilities. */
  class RemoteFlowSourceAsSource extends Source instanceof RemoteFlowSource { }

  /**
   * A call to an XML parser that is vulnerable to XML bombs.
   */
  class XmlParsingVulnerableToXmlBomb extends Sink {
    XmlParsingVulnerableToXmlBomb() {
      exists(XML::XmlParsing parsing, XML::XmlParsingVulnerabilityKind kind |
        kind.isXmlBomb() and
        parsing.vulnerableTo(kind) and
        this = parsing.getAnInput()
      )
    }
  }
}
