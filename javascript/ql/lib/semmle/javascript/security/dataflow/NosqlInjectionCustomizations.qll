/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * NoSQL injection vulnerabilities, as well as extension points for
 * adding your own.
 */

import javascript
import semmle.javascript.security.TaintedObject

module NosqlInjection {
  import semmle.javascript.security.CommonFlowState

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
    FlowState getAFlowState() { result.isTaintedObject() }

    /** DEPRECATED. Use `getAFlowState()` instead. */
    deprecated DataFlow::FlowLabel getAFlowLabel() { result = this.getAFlowState().toFlowLabel() }
  }

  /**
   * A sanitizer for NoSQL injection vulnerabilities.
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

  /** An expression interpreted as a NoSql query, viewed as a sink. */
  class NosqlQuerySink extends Sink instanceof NoSql::Query { }
}
