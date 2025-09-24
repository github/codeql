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
    TPermissive()

  /** A flow state to associate with a tracked value. */
  class FlowState extends TFlowState {
    /** Gets a string representation of this flow state. */
    string toString() {
      this = TTaint() and result = "taint"
      or
      this = TPermissive() and result = "permissive"
    }
  }

  /** Predicates for working with flow states. */
  module FlowState {
    /** A tainted value. */
    FlowState taint() { result = TTaint() }

    /** A permissive value (true, null, or "*"). */
    FlowState permissive() { result = TPermissive() }
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

  /** An overly permissive value for `origin` configuration. */
  class PermissiveValue extends Source {
    PermissiveValue() {
      this.mayHaveBooleanValue(true) or
      this.asExpr() instanceof NullLiteral or
      this.mayHaveStringValue("*")
    }
  }

  /**
   * The value of cors origin when initializing the application.
   */
  class CorsOriginSink extends Sink, DataFlow::ValueNode {
    CorsOriginSink() { this = ModelOutput::getASinkNode("cors-origin").asSink() }
  }

  /**
   * A sanitizer for CORS configurations where credentials are explicitly disabled.
   * When credentials are false, using "*" for origin is a legitimate pattern.
   */
  private class CredentialsDisabledSanitizer extends Sanitizer {
    CredentialsDisabledSanitizer() {
      exists(DataFlow::SourceNode config, DataFlow::CallNode call |
        call.getArgument(0).getALocalSource() = config and
        this = config.getAPropertyWrite("origin").getRhs() and
        config.getAPropertyWrite("credentials").getRhs().mayHaveBooleanValue(false)
      )
    }
  }
}
