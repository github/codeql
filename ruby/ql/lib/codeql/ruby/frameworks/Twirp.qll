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
  class ServiceInstantiation extends DataFlow::CallNode {
    ServiceInstantiation() {
      this = API::getTopLevelMember("Twirp").getMember("Service").getAnInstantiation()
    }

    private DataFlow::ClassNode getAHandlerClass() {
      result.getAnImmediateReference().getAMethodCall("new").flowsTo(this.getArgument(0))
    }

    /**
     * Gets a handler's method.
     */
    Ast::Method getAHandlerMethod() {
      result = this.getAHandlerClass().getAnAncestor().getAnOwnInstanceMethod().asCallableAstNode()
    }
  }

  /**
   * A Twirp client
   */
  class ClientInstantiation extends DataFlow::CallNode {
    ClientInstantiation() {
      this = API::getTopLevelMember("Twirp").getMember("Client").getAnInstantiation()
    }
  }

  /** The URL of a Twirp service, considered as a sink. */
  class ServiceUrlAsSsrfSink extends ServerSideRequestForgery::Sink {
    ServiceUrlAsSsrfSink() { exists(ClientInstantiation c | c.getArgument(0) = this) }
  }

  /** A parameter that will receive parts of the url when handling an incoming request. */
  class UnmarshaledParameter extends Http::Server::RequestInputAccess::Range,
    DataFlow::ParameterNode
  {
    UnmarshaledParameter() {
      exists(ServiceInstantiation i | i.getAHandlerMethod().getParameter(0) = this.asParameter())
    }

    override string getSourceType() { result = "Twirp Unmarhaled Parameter" }

    override Http::Server::RequestInputKind getKind() { result = Http::Server::bodyInputKind() }
  }
}
