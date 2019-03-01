/**
 * Provides classes for working with [Koa](https://koajs.com) applications.
 */

import javascript
import semmle.javascript.frameworks.HTTP

module Koa {
  /**
   * An expression that creates a new Koa application.
   */
  class AppDefinition extends HTTP::Servers::StandardServerDefinition, NewExpr {
    AppDefinition() {
      // `app = new Koa()`
      this = DataFlow::moduleImport("koa").getAnInvocation().asExpr()
    }
  }

  /**
   * An HTTP header defined in a Koa application.
   */
  private class HeaderDefinition extends HTTP::Servers::StandardHeaderDefinition {
    RouteHandler rh;

    HeaderDefinition() {
      // ctx.set('Cache-Control', 'no-cache');
      astNode.calls(rh.getAContextExpr(), "set")
      or
      // ctx.response.header('Cache-Control', 'no-cache')
      astNode.calls(rh.getAResponseExpr(), "header")
    }

    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A Koa route handler.
   */
  class RouteHandler extends HTTP::Servers::StandardRouteHandler, DataFlow::ValueNode {
    Function function;

    RouteHandler() {
      function = astNode and
      any(RouteSetup setup).getARouteHandler() = this
    }

    /**
     * Gets the parameter of the route handler that contains the context object.
     */
    SimpleParameter getContextParameter() { result = function.getParameter(0) }

    /**
     * Gets an expression that contains the "context" object of
     * a route handler invocation.
     *
     * Explanation: the context-object in Koa is typically
     * `this` or `ctx`, given as the first and only argument to the
     * route handler.
     */
    Expr getAContextExpr() { result.(ContextExpr).getRouteHandler() = this }
  }

  /**
   * A Koa context source, that is, the context parameter of a
   * route handler, or a `this` access in a route handler.
   */
  private class ContextSource extends DataFlow::TrackedNode {
    RouteHandler rh;

    ContextSource() {
      this = DataFlow::parameterNode(rh.getContextParameter())
      or
      this.(DataFlow::ThisNode).getBinder() = rh
    }

    /**
     * Gets the route handler that handles this request.
     */
    RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A Koa request source, that is, an access to the `request` property
   * of a context object.
   */
  private class RequestSource extends HTTP::Servers::RequestSource {
    ContextExpr ctx;

    RequestSource() { asExpr().(PropAccess).accesses(ctx, "request") }

    /**
     * Gets the route handler that provides this response.
     */
    override RouteHandler getRouteHandler() { result = ctx.getRouteHandler() }
  }

  /**
   * A Koa response source, that is, an access to the `response` property
   * of a context object.
   */
  private class ResponseSource extends HTTP::Servers::ResponseSource {
    ContextExpr ctx;

    ResponseSource() { asExpr().(PropAccess).accesses(ctx, "response") }

    /**
     * Gets the route handler that provides this response.
     */
    override RouteHandler getRouteHandler() { result = ctx.getRouteHandler() }
  }

  /**
   * An expression that may hold a Koa context object.
   */
  class ContextExpr extends Expr {
    ContextSource src;

    ContextExpr() { src.flowsTo(DataFlow::valueNode(this)) }

    /**
     * Gets the route handler that provides this response.
     */
    RouteHandler getRouteHandler() { result = src.getRouteHandler() }
  }

  /**
   * An expression that may hold a Koa request object.
   */
  class RequestExpr extends HTTP::Servers::StandardRequestExpr {
    override RequestSource src;
  }

  /**
   * An expression that may hold a Koa response object.
   */
  class ResponseExpr extends HTTP::Servers::StandardResponseExpr {
    override ResponseSource src;
  }

  /**
   * An access to a user-controlled Koa request input.
   */
  private class RequestInputAccess extends HTTP::RequestInputAccess {
    RouteHandler rh;

    string kind;

    RequestInputAccess() {
      exists(Expr request | request = rh.getARequestExpr() |
        // `ctx.request.body`
        kind = "body" and
        this.asExpr().(PropAccess).accesses(request, "body")
        or
        kind = "parameter" and
        this = getAQueryParameterAccess(rh)
        or
        exists(string propName |
          // `ctx.request.url`, `ctx.request.originalUrl`, or `ctx.request.href`
          kind = "url" and
          this.asExpr().(PropAccess).accesses(request, propName)
        |
          propName = "url" or
          propName = "originalUrl" or
          propName = "href"
        )
      )
      or
      exists(PropAccess cookies |
        // `ctx.cookies.get(<name>)`
        kind = "cookie" and
        cookies.accesses(rh.getAContextExpr(), "cookies") and
        this.asExpr().(MethodCallExpr).calls(cookies, "get")
      )
      or
      exists(RequestHeaderAccess access | access = this |
        rh = access.getRouteHandler() and
        kind = "header"
      )
    }

    override RouteHandler getRouteHandler() { result = rh }

    override string getKind() { result = kind }

    override predicate isUserControlledObject() { this = getAQueryParameterAccess(rh) }
  }

  private DataFlow::Node getAQueryParameterAccess(RouteHandler rh) {
    // `ctx.request.query.name`
    result.asExpr().(PropAccess).getBase().(PropAccess).accesses(rh.getARequestExpr(), "query")
  }

  /**
   * An access to an HTTP header on a Koa request.
   */
  private class RequestHeaderAccess extends HTTP::RequestHeaderAccess {
    RouteHandler rh;

    RequestHeaderAccess() {
      exists(Expr request | request = rh.getARequestExpr() |
        exists(string propName, PropAccess headers |
          // `ctx.request.header.<name>`, `ctx.request.headers.<name>`
          headers.accesses(request, propName) and
          this.asExpr().(PropAccess).accesses(headers, _)
        |
          propName = "header" or
          propName = "headers"
        )
        or
        // `ctx.request.get(<name>)`
        this.asExpr().(MethodCallExpr).calls(request, "get")
      )
    }

    override string getAHeaderName() {
      result = this.(DataFlow::PropRead).getPropertyName().toLowerCase()
      or
      exists(string name |
        this.(DataFlow::CallNode).getArgument(0).mayHaveStringValue(name) and
        result = name.toLowerCase()
      )
    }

    override RouteHandler getRouteHandler() { result = rh }

    override string getKind() { result = "header" }
  }

  /**
   * A call to a Koa method that sets up a route.
   */
  class RouteSetup extends HTTP::Servers::StandardRouteSetup, MethodCallExpr {
    AppDefinition server;

    RouteSetup() {
      // app.use(fun)
      server.flowsTo(getReceiver()) and
      getMethodName() = "use"
    }

    override DataFlow::SourceNode getARouteHandler() { result.flowsToExpr(getArgument(0)) }

    override Expr getServer() { result = server }
  }

  /**
   * A value assigned to the body of an HTTP response object.
   */
  private class ResponseSendArgument extends HTTP::ResponseSendArgument {
    RouteHandler rh;

    ResponseSendArgument() {
      exists(DataFlow::PropWrite pwn |
        pwn.writes(DataFlow::valueNode(rh.getAResponseExpr()), "body", DataFlow::valueNode(this))
      )
    }

    override RouteHandler getRouteHandler() { result = rh }
  }
}
