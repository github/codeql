/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * overly permissive CORS configurations, as well as
 * extension points for adding your own.
 */

import javascript
import Cors::Cors
import Apollo::Apollo

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

    deprecated DataFlow::FlowLabel toFlowLabel() {
      this = TTaint() and result.isTaint()
      or
      this = TTrueOrNull() and result instanceof TrueAndNull
      or
      this = TWildcard() and result instanceof Wildcard
    }
  }

  /** Predicates for working with flow states. */
  module FlowState {
    deprecated FlowState fromFlowLabel(DataFlow::FlowLabel label) { result.toFlowLabel() = label }

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
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source instanceof ActiveThreatModelSource {
    ActiveThreatModelSourceAsSource() { not this instanceof ClientSideRemoteFlowSource }
  }

  /** A flow label representing `true` and `null` values. */
  abstract deprecated class TrueAndNull extends DataFlow::FlowLabel {
    TrueAndNull() { this = "TrueAndNull" }
  }

  deprecated TrueAndNull truenullLabel() { any() }

  /** A flow label representing `*` value. */
  abstract deprecated class Wildcard extends DataFlow::FlowLabel {
    Wildcard() { this = "Wildcard" }
  }

  deprecated Wildcard wildcardLabel() { any() }

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
  class CorsApolloServer extends Sink, DataFlow::ValueNode {
    CorsApolloServer() {
      exists(ApolloServer agql |
        this =
          agql.getOptionArgument(0, "cors").getALocalSource().getAPropertyWrite("origin").getRhs()
      )
    }
  }

  /**
   * The value of cors origin when initializing the application.
   */
  class ExpressCors extends Sink, DataFlow::ValueNode {
    ExpressCors() {
      exists(CorsConfiguration config | this = config.getCorsConfiguration().getOrigin())
    }
  }

  /**
   * An express route setup configured with the `cors` package.
   */
  class CorsConfiguration extends DataFlow::MethodCallNode {
    Cors corsConfig;

    CorsConfiguration() {
      exists(Express::RouteSetup setup | this = setup |
        if setup.isUseCall()
        then corsConfig = setup.getArgument(0)
        else corsConfig = setup.getArgument(any(int i | i > 0))
      )
    }

    /** Gets the expression that configures `cors` on this route setup. */
    Cors getCorsConfiguration() { result = corsConfig }
  }
}
