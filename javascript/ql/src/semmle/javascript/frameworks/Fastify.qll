/**
 * Provides classes for working with [Fastify](https://www.fastify.io/) applications.
 */

import javascript
import semmle.javascript.frameworks.HTTP

/**
 * Provides classes for working with [Fastify](https://www.fastify.io/) applications.
 */
module Fastify {
  /**
   * An expression that creates a new Fastify server.
   */
  abstract class ServerDefinition extends HTTP::Servers::StandardServerDefinition { }

  /**
   * A standard way to create a Fastify server.
   */
  class StandardServerDefinition extends ServerDefinition {
    StandardServerDefinition() {
      this = DataFlow::moduleImport("fastify").getAnInvocation().asExpr()
    }
  }

  /**
   * A function used as a Fastify route handler.
   *
   * By default, only handlers installed by a Fastify route setup are recognized,
   * but support for other kinds of route handlers can be added by implementing
   * additional subclasses of this class.
   */
  abstract class RouteHandler extends HTTP::Servers::StandardRouteHandler, DataFlow::ValueNode {
    /**
     * Gets the parameter of the route handler that contains the request object.
     */
    abstract DataFlow::ParameterNode getRequestParameter();

    /**
     * Gets the parameter of the route handler that contains the reply object.
     */
    abstract DataFlow::ParameterNode getReplyParameter();
  }

  /**
   * A Fastify route handler installed by a route setup.
   */
  class StandardRouteHandler extends RouteHandler, DataFlow::FunctionNode {
    StandardRouteHandler() { this = any(RouteSetup setup).getARouteHandler() }

    override DataFlow::ParameterNode getRequestParameter() { result = this.getParameter(0) }

    override DataFlow::ParameterNode getReplyParameter() { result = this.getParameter(1) }
  }

  /**
   * A Fastify reply source, that is, the `reply` parameter of a
   * route handler.
   */
  private class ReplySource extends HTTP::Servers::ResponseSource {
    RouteHandler rh;

    ReplySource() { this = rh.getReplyParameter() }

    /**
     * Gets the route handler that provides this response.
     */
    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A Fastify request source, that is, the request parameter of a
   * route handler.
   */
  private class RequestSource extends HTTP::Servers::RequestSource {
    RouteHandler rh;

    RequestSource() { this = rh.getRequestParameter() }

    /**
     * Gets the route handler that handles this request.
     */
    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A call to a Fastify method that sets up a route.
   */
  class RouteSetup extends MethodCallExpr, HTTP::Servers::StandardRouteSetup {
    ServerDefinition server;
    string methodName;

    RouteSetup() {
      this.getMethodName() = methodName and
      methodName = ["route", "get", "head", "post", "put", "delete", "options", "patch"] and
      server.flowsTo(this.getReceiver())
    }

    override DataFlow::SourceNode getARouteHandler() {
      result = getARouteHandler(DataFlow::TypeBackTracker::end())
    }

    private DataFlow::SourceNode getARouteHandler(DataFlow::TypeBackTracker t) {
      t.start() and
      result = this.getARouteHandlerExpr().getALocalSource()
      or
      exists(DataFlow::TypeBackTracker t2 | result = this.getARouteHandler(t2).backtrack(t2, t))
    }

    override Expr getServer() { result = server }

    /** Gets an argument that represents a route handler being registered. */
    private DataFlow::Node getARouteHandlerExpr() {
      if methodName = "route"
      then
        result =
          this
              .flow()
              .(DataFlow::MethodCallNode)
              .getOptionArgument(0,
                [
                  "onRequest", "preParsing", "preValidation", "preHandler", "preSerialization",
                  "onSend", "onResponse", "handler"
                ])
      else result = getLastArgument().flow()
    }
  }

  /**
   * An access to a user-controlled Fastify request input.
   */
  private class RequestInputAccess extends HTTP::RequestInputAccess {
    RouteHandler rh;
    string kind;

    RequestInputAccess() {
      exists(string name | this = rh.getARequestSource().ref().getAPropertyRead(name) |
        kind = "parameter" and
        name = ["params", "query"]
        or
        kind = "body" and
        name = "body"
      )
    }

    override RouteHandler getRouteHandler() { result = rh }

    override string getKind() { result = kind }

    override predicate isUserControlledObject() {
      kind = "body" and
      (
        usesFastifyPlugin(rh,
          DataFlow::moduleImport(["fastify-xml-body-parser", "fastify-formbody"]))
        or
        usesMiddleware(rh,
          any(ExpressLibraries::BodyParser bodyParser | bodyParser.producesUserControlledObjects()))
      )
      or
      kind = "parameter" and
      usesFastifyPlugin(rh, DataFlow::moduleImport("fastify-qs"))
    }
  }

  /**
   * Holds if `rh` uses `plugin`.
   */
  private predicate usesFastifyPlugin(RouteHandler rh, DataFlow::SourceNode plugin) {
    exists(RouteSetup setup |
      plugin
          .flowsTo(setup
                .getServer()
                .flow()
                .(DataFlow::SourceNode)
                .getAMethodCall("register")
                .getArgument(0)) and // only matches the plugins that apply to all routes
      rh = setup.getARouteHandler()
    )
  }

  /**
   * Holds if `rh` uses `plugin`.
   */
  private predicate usesMiddleware(RouteHandler rh, DataFlow::SourceNode middleware) {
    exists(RouteSetup setup |
      middleware
          .flowsTo(setup
                .getServer()
                .flow()
                .(DataFlow::SourceNode)
                .getAMethodCall("use")
                .getArgument(0)) and // only matches the middlewares that apply to all routes
      rh = setup.getARouteHandler()
    )
  }

  /**
   * An access to a header on a Fastify request.
   */
  private class RequestHeaderAccess extends HTTP::RequestHeaderAccess {
    RouteHandler rh;

    RequestHeaderAccess() {
      this = rh.getARequestSource().ref().getAPropertyRead("headers").getAPropertyRead()
    }

    override string getAHeaderName() {
      result = this.(DataFlow::PropRead).getPropertyName().toLowerCase()
    }

    override RouteHandler getRouteHandler() { result = rh }

    override string getKind() { result = "header" }
  }

  /**
   * An argument passed to the `send` or `end` method of an HTTP response object.
   */
  private class ResponseSendArgument extends HTTP::ResponseSendArgument {
    RouteHandler rh;

    ResponseSendArgument() {
      this = rh.getAResponseSource().ref().getAMethodCall("send").getArgument(0).asExpr()
      or
      this = rh.(DataFlow::FunctionNode).getAReturn().asExpr()
    }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * An invocation of the `redirect` method of an HTTP response object.
   */
  private class RedirectInvocation extends HTTP::RedirectInvocation, MethodCallExpr {
    RouteHandler rh;

    RedirectInvocation() {
      this = rh.getAResponseSource().ref().getAMethodCall("redirect").asExpr()
    }

    override Expr getUrlArgument() { result = this.getLastArgument() }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * An invocation that sets a single header of the HTTP response.
   */
  private class SetOneHeader extends HTTP::Servers::StandardHeaderDefinition,
    DataFlow::MethodCallNode {
    RouteHandler rh;

    SetOneHeader() {
      this = rh.getAResponseSource().ref().getAMethodCall("header") and
      this.getNumArgument() = 2
    }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * An invocation that sets any number of headers of the HTTP response.
   */
  class SetMultipleHeaders extends HTTP::ExplicitHeaderDefinition, DataFlow::MethodCallNode {
    RouteHandler rh;

    SetMultipleHeaders() {
      this = rh.getAResponseSource().ref().getAMethodCall("headers") and
      this.getNumArgument() = 1
    }

    /**
     * Gets a reference to the multiple headers object that is to be set.
     */
    private DataFlow::SourceNode getAHeaderSource() { result.flowsTo(this.getArgument(0)) }

    override predicate definesExplicitly(string headerName, Expr headerValue) {
      exists(string header |
        getAHeaderSource().hasPropertyWrite(header, headerValue.flow()) and
        headerName = header.toLowerCase()
      )
    }

    override RouteHandler getRouteHandler() { result = rh }

    override Expr getNameExpr() {
      exists(DataFlow::PropWrite write |
        this.getAHeaderSource().flowsTo(write.getBase()) and
        result = write.getPropertyNameExpr()
      )
    }
  }
}
