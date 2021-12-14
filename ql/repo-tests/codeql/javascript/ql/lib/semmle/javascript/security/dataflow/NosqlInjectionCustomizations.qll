/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * NoSQL injection vulnerabilities, as well as extension points for
 * adding your own.
 */

import javascript
import semmle.javascript.security.TaintedObject

module NosqlInjection {
  /**
   * A data flow source for NoSQL injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for NoSQL injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets a flow label relevant for this sink.
     *
     * Defaults to deeply tainted objects only.
     */
    DataFlow::FlowLabel getAFlowLabel() { result = TaintedObject::label() }
  }

  /**
   * A sanitizer for NoSQL injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A source of remote user input, considered as a flow source for NoSQL injection. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /** An expression interpreted as a NoSQL query, viewed as a sink. */
  class NosqlQuerySink extends Sink, DataFlow::ValueNode {
    override NoSQL::Query astNode;
  }
}
