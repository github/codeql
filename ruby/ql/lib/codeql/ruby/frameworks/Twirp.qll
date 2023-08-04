/**
 * Provides classes for modeling the `Twirp` framework.
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.CFG
private import codeql.ruby.ApiGraphs
private import codeql.ruby.AST as Ast
private import codeql.ruby.security.ServerSideRequestForgeryCustomizations
private import codeql.ruby.Concepts

/**
 * Provides classes for modeling the `Twirp` framework.
 */
module Twirp {
  /**
   * A Twirp service instantiation
   */
  deprecated class ServiceInstantiation extends DataFlow::CallNode {
    ServiceInstantiation() {
      this = API::getTopLevelMember("Twirp").getMember("Service").getAnInstantiation()
    }

    /**
     * Gets a handler's method.
     */
    DataFlow::MethodNode getAHandlerMethodNode() {
      result = this.getArgument(0).backtrack().getMethod(_).asCallable()
    }

    /**
     * Gets a handler's method as an AST node.
     */
    Ast::Method getAHandlerMethod() { result = this.getAHandlerMethodNode().asCallableAstNode() }
  }

  /**
   * A Twirp client
   */
  deprecated class ClientInstantiation extends DataFlow::CallNode {
    ClientInstantiation() {
      this = API::getTopLevelMember("Twirp").getMember("Client").getAnInstantiation()
    }
  }

  /** The URL of a Twirp service, considered as a sink. */
  class ServiceUrlAsSsrfSink extends ServerSideRequestForgery::Sink {
    ServiceUrlAsSsrfSink() {
      this =
        API::getTopLevelMember("Twirp").getMember("Client").getMethod("new").getArgument(0).asSink()
    }
  }

  /** A parameter that will receive parts of the url when handling an incoming request. */
  class UnmarshaledParameter extends Http::Server::RequestInputAccess::Range,
    DataFlow::ParameterNode
  {
    UnmarshaledParameter() {
      this =
        API::getTopLevelMember("Twirp")
            .getMember("Service")
            .getMethod("new")
            .getArgument(0)
            .getMethod(_)
            .getParameter(0)
            .asSource()
    }

    override string getSourceType() { result = "Twirp Unmarhaled Parameter" }

    override Http::Server::RequestInputKind getKind() { result = Http::Server::bodyInputKind() }
  }
}
