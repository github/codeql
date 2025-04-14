/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * XML-bomb vulnerabilities, as well as extension points for adding
 * your own.
 */

import javascript
import semmle.javascript.security.dataflow.DOM

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

  /**
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /**
   * An access to `document.location`, considered as a flow source for XML bomb vulnerabilities.
   */
  class LocationAsSource extends Source {
    LocationAsSource() { isLocationNode(this) }
  }

  /**
   * A call to an XML parser that performs internal entity expansion, viewed
   * as a data flow sink for XML-bomb vulnerabilities.
   */
  class XmlParsingWithEntityResolution extends Sink, DataFlow::ValueNode {
    XmlParsingWithEntityResolution() {
      exists(XML::ParserInvocation parse | astNode = parse.getSourceArgument() |
        parse.resolvesEntities(XML::InternalEntity())
      )
    }
  }
}
