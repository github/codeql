/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * overly permissive CORS configurations, as well as
 * extension points for adding your own.
 */

import javascript

module CorsPermissiveConfiguration {
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

  /** A source of remote user input, considered as a flow source for CORS misconfiguration. */
  class RemoteFlowSourceAsSource extends Source instanceof RemoteFlowSource {
    RemoteFlowSourceAsSource() { not this instanceof ClientSideRemoteFlowSource }
  }

  /** true and null are considered bad values */
  class BadValues extends Source instanceof DataFlow::Node {
    BadValues() { this.mayHaveBooleanValue(true) or this.asExpr() instanceof NullLiteral }
  }

  /**
   * The value of cors origin when initializing the application.
   */
  class CorsApolloServer extends Sink, DataFlow::ValueNode {
    CorsApolloServer() {
      exists(ApolloGraphQL::ApolloGraphQLServer agql |
        this =
          agql.(DataFlow::NewNode)
              .getOptionArgument(0, "cors")
              .getALocalSource()
              .getAPropertyWrite("origin")
              .getRhs()
      )
    }
  }
}
