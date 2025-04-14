/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * XML External Entity (XXE) vulnerabilities, as well as extension
 * points for adding your own.
 */

import javascript
import semmle.javascript.security.dataflow.DOM

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

  /**
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /**
   * An access to `document.location`, considered as a flow source for XXE vulnerabilities.
   */
  class LocationAsSource extends Source {
    LocationAsSource() { isLocationNode(this) }
  }

  /**
   * A call to an XML parser that performs external entity expansion, viewed
   * as a data flow sink for XXE vulnerabilities.
   */
  class XmlParsingWithExternalEntityResolution extends Sink, DataFlow::ValueNode {
    XmlParsingWithExternalEntityResolution() {
      exists(XML::ParserInvocation parse | astNode = parse.getSourceArgument() |
        parse.resolvesEntities(XML::ExternalEntity(_))
        or
        parse.resolvesEntities(XML::ParameterEntity(true)) and
        parse.resolvesEntities(XML::InternalEntity())
      )
    }
  }
}
