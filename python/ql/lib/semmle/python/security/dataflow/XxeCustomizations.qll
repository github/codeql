/**
 * Provides default sources, sinks and sanitizers for detecting
 * "XML External Entity (XXE)"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources

/**
 * Provides default sources, sinks and sanitizers for detecting "XML External Entity (XXE)"
 * vulnerabilities, as well as extension points for adding your own.
 */
module Xxe {
  /**
   * A data flow source for XXE vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for XXE vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for XXE vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A source of remote user input, considered as a flow source for XXE vulnerabilities. */
  class RemoteFlowSourceAsSource extends Source instanceof RemoteFlowSource { }

  /**
   * A call to an XML parser that is vulnerable to XXE.
   */
  class XmlParsingVulnerableToXxe extends Sink {
    XmlParsingVulnerableToXxe() {
      exists(XML::XmlParsing parsing, XML::XmlParsingVulnerabilityKind kind |
        kind.isXxe() and
        parsing.vulnerableTo(kind) and
        this = parsing.getAnInput()
      )
    }
  }

  /**
   * An XML escaping, considered as a sanitizer.
   */
  class XmlEscapingAsSanitizer extends Sanitizer {
    XmlEscapingAsSanitizer() { this = any(XmlEscaping esc).getOutput() }
  }
}
