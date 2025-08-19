/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * CORS misconfiguration for credentials transfer and overly permissive CORS configurations,
 * as well as extension points for adding your own.
 */

import javascript
private import semmle.javascript.frameworks.Cors

module CorsMisconfigurationForCredentials {
  /**
   * A data flow source for CORS misconfiguration for credentials transfer and overly permissive CORS configurations.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for CORS misconfiguration for credentials transfer.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the "Access-Control-Allow-Credentials" header definition.
     */
    abstract Http::HeaderDefinition getCredentialsHeader();
  }

  /**
   * A sanitizer for CORS misconfiguration for credentials transfer.
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
    ActiveThreatModelSourceAsSource() { not this.isClientSideSource() }
  }

  /**
   * The value of an "Access-Control-Allow-Origin" HTTP
   * header with an associated "Access-Control-Allow-Credentials"
   * HTTP header with a truthy value.
   */
  class CorsOriginHeaderWithAssociatedCredentialHeader extends Sink, DataFlow::ValueNode {
    Http::ExplicitHeaderDefinition credentials;

    CorsOriginHeaderWithAssociatedCredentialHeader() {
      exists(
        Http::RouteHandler routeHandler, Http::ExplicitHeaderDefinition origin,
        DataFlow::Node credentialsValue
      |
        routeHandler.getAResponseHeader(_) = origin and
        routeHandler.getAResponseHeader(_) = credentials and
        origin.definesHeaderValue("access-control-allow-origin", this) and
        credentials.definesHeaderValue("access-control-allow-credentials", credentialsValue)
      |
        credentialsValue.mayHaveBooleanValue(true) or
        credentialsValue.mayHaveStringValue("true")
      )
    }

    override Http::HeaderDefinition getCredentialsHeader() { result = credentials }
  }

  /**
   * A value that is or coerces to the string "null".
   * This is considered a source because the "null" origin is easy to obtain for an attacker.
   */
  class NullToStringValue extends Source {
    NullToStringValue() {
      this.asExpr() instanceof NullLiteral or
      this.asExpr().mayHaveStringValue("null")
    }
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
  class CorsApolloServer extends Sink, DataFlow::ValueNode {
    CorsApolloServer() {
      exists(API::NewNode agql |
        agql = ModelOutput::getATypeNode("ApolloServer").getAnInstantiation() and
        this =
          agql.getOptionArgument(0, "cors").getALocalSource().getAPropertyWrite("origin").getRhs()
      )
    }

    override Http::HeaderDefinition getCredentialsHeader() { none() }
  }

  /**
   * The value of cors origin when initializing the application.
   */
  class ExpressCors extends Sink, DataFlow::ValueNode {
    ExpressCors() {
      exists(CorsConfiguration config | this = config.getCorsConfiguration().getOrigin())
    }

    override Http::HeaderDefinition getCredentialsHeader() { none() }
  }

  /**
   * An express route setup configured with the `cors` package.
   */
  class CorsConfiguration extends DataFlow::MethodCallNode {
    Cors::Cors corsConfig;

    CorsConfiguration() {
      exists(Express::RouteSetup setup | this = setup |
        if setup.isUseCall()
        then corsConfig = setup.getArgument(0)
        else corsConfig = setup.getArgument(any(int i | i > 0))
      )
    }

    /** Gets the expression that configures `cors` on this route setup. */
    Cors::Cors getCorsConfiguration() { result = corsConfig }
  }
}
