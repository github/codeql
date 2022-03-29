/**
 * Provides default sources, sinks and sanitizers for detecting
 * "XML External Entity (XXE)"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
import experimental.semmle.python.frameworks.Xml // needed until modeling have been promoted
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
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * A call to an XML parser that performs external entity expansion, viewed
   * as a data flow sink for XXE vulnerabilities.
   */
  class XmlParsingWithExternalEntityResolution extends Sink {
    XmlParsingWithExternalEntityResolution() {
      exists(XML::XMLParsing parsing, XML::XMLVulnerabilityKind kind |
        kind.isXxe() and
        parsing.vulnerableTo(kind) and
        this = parsing.getAnInput()
      )
    }
  }
}
