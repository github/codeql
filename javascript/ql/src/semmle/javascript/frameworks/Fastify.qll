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
   * By default, only handlers installed by an Fastify route setup are recognized,
   * but support for other kinds of route handlers can be added by implementing
   * additional subclasses of this class.
   */
  abstract class RouteHandler extends HTTP::Servers::StandardRouteHandler, DataFlow::ValueNode {
    /**
     * Gets the parameter of the route handler that contains the request object.
     */
    abstract SimpleParameter getRequestParameter();

    /**
     * Gets the parameter of the route handler that contains the reply object.
     */
    abstract SimpleParameter getReplyParameter();
  }

  /**
   * A Fastify route handler installed by a route setup.
   */
  class StandardRouteHandler extends RouteHandler, DataFlow::FunctionNode {
    StandardRouteHandler() { this = any(RouteSetup setup).getARouteHandler() }

    override SimpleParameter getRequestParameter() { result = this.getParameter(0).getParameter() }

    override SimpleParameter getReplyParameter() { result = this.getParameter(1).getParameter() }
  }

  /**
   * A Fastify reply source, that is, the `reply` parameter of a
   * route handler.
   */
  private class ReplySource extends HTTP::Servers::ResponseSource {
    RouteHandler rh;

    ReplySource() { this = DataFlow::parameterNode(rh.getReplyParameter()) }

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

    RequestSource() { this = DataFlow::parameterNode(rh.getRequestParameter()) }

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
                ["onRequest", "preParsing", "preValidation", "preHandler", "preSerialization",
                    "onSend", "onResponse", "handler"])
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
      exists(string name | this.(DataFlow::PropRead).accesses(rh.getARequestExpr().flow(), name) |
        kind = "parameter" and
        name = ["params", "query"]
        or
        kind = "body" and
        name = "body"
      )
    }

    override RouteHandler getRouteHandler() { result = rh }

    override string getKind() { result = kind }
  }

  /**
   * An access to a header on a Fastify request.
   */
  private class RequestHeaderAccess extends HTTP::RequestHeaderAccess {
    RouteHandler rh;

    RequestHeaderAccess() {
      exists(DataFlow::PropRead headers |
        headers.accesses(rh.getARequestExpr().flow(), "headers") and
        this = headers.getAPropertyRead()
      )
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
      exists(MethodCallExpr mce |
        mce.calls(rh.getAResponseExpr(), "send") and
        this = mce.getArgument(0)
      )
      or
      exists(Function f |
        f = rh.(DataFlow::FunctionNode).getFunction() and
        f.isAsync() and
        f.getAReturnedExpr() = this
      )
    }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * An invocation of the `redirect` method of an HTTP response object.
   */
  private class RedirectInvocation extends HTTP::RedirectInvocation, MethodCallExpr {
    RouteHandler rh;

    RedirectInvocation() { this.calls(rh.getAResponseExpr(), "redirect") }

    override Expr getUrlArgument() { result = this.getLastArgument() }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * An invocation that sets a single header of the HTTP response.
   */
  private class SetOneHeader extends HTTP::Servers::StandardHeaderDefinition {
    RouteHandler rh;

    SetOneHeader() {
      astNode.calls(rh.getAResponseExpr(), "header") and
      astNode.getNumArgument() = 2
    }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * An invocation that sets any number of headers of the HTTP response.
   */
  class SetMultipleHeaders extends HTTP::ExplicitHeaderDefinition, DataFlow::MethodCallNode {
    RouteHandler rh;

    SetMultipleHeaders() {
      this.calls(rh.getAResponseExpr().flow(), "headers") and
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
