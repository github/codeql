/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * overly permissive CORS configurations, as well as
 * extension points for adding your own.
 */

import javascript

/** Module containing sources, sinks, and sanitizers for overly permissive CORS configurations. */
module CorsPermissiveConfiguration {
  private newtype TFlowState =
    TTaint() or
    TTrueOrNull() or
    TWildcard()

  /** A flow state to asociate with a tracked value. */
  class FlowState extends TFlowState {
    /** Gets a string representation of this flow state. */
    string toString() {
      this = TTaint() and result = "taint"
      or
      this = TTrueOrNull() and result = "true-or-null"
      or
      this = TWildcard() and result = "wildcard"
    }
  }

  /** Predicates for working with flow states. */
  module FlowState {
    /** A tainted value. */
    FlowState taint() { result = TTaint() }

    /** A `true` or `null` value. */
    FlowState trueOrNull() { result = TTrueOrNull() }

    /** A `"*"` value. */
    FlowState wildcard() { result = TWildcard() }
  }

  /**
   * A data flow source for permissive CORS configuration.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for permissive CORS configuration.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for permissive CORS configuration.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source instanceof ActiveThreatModelSource {
    ActiveThreatModelSourceAsSource() { not this instanceof ClientSideRemoteFlowSource }
  }

  /** An overly permissive value for `origin` (Apollo) */
  class TrueNullValue extends Source {
    TrueNullValue() { this.mayHaveBooleanValue(true) or this.asExpr() instanceof NullLiteral }
  }

  /** An overly permissive value for `origin` (Express) */
  class WildcardValue extends Source {
    WildcardValue() { this.mayHaveStringValue("*") }
  }

  /**
   * The value of cors origin when initializing the application.
   */
  class CorsOriginSink extends Sink, DataFlow::ValueNode {
    CorsOriginSink() { this = ModelOutput::getASinkNode("cors-misconfiguration").asSink() }
  }
}
