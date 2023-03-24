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
      this =
        API::getTopLevelMember("Twirp").getMember("Service").getASubclass().getAnInstantiation()
    }

    /**
     * Gets a local source node for the Service instantiation argument (the service handler).
     */
    private DataFlow::LocalSourceNode getHandlerSource() {
      result = this.getArgument(0).getALocalSource()
    }

    /**
     * Gets the API::Node for the service handler's class.
     */
    private API::Node getAHandlerClassApiNode() {
      result.getAnInstantiation() = this.getHandlerSource()
    }

    /**
     * Gets the AST module for the service handler's class.
     */
    private Ast::Module getAHandlerClassAstNode() {
      result =
        this.getAHandlerClassApiNode()
            .asSource()
            .asExpr()
            .(CfgNodes::ExprNodes::ConstantReadAccessCfgNode)
            .getExpr()
            .getModule()
    }

    /**
     * Gets a handler's method.
     */
    Ast::Method getAHandlerMethod() {
      result = this.getAHandlerClassAstNode().getAnInstanceMethod()
    }
  }

  /**
   * A Twirp client
   */
  class ClientInstantiation extends DataFlow::CallNode {
    ClientInstantiation() {
      this = API::getTopLevelMember("Twirp").getMember("Client").getASubclass().getAnInstantiation()
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
