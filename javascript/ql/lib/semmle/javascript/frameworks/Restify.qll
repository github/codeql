/**
 * Provides classes for working with [Restify](https://restify.com/) servers.
 */

import javascript
import semmle.javascript.frameworks.HTTP

module Restify {
  /**
   * An expression that creates a new Restify server.
   */
  class ServerDefinition extends Http::Servers::StandardServerDefinition, DataFlow::CallNode {
    ServerDefinition() {
      // `server = restify.createServer()`
      this = DataFlow::moduleMember("restify", "createServer").getACall()
    }
  }

  /**
   * A Restify route handler.
   */
  class RouteHandler extends Http::Servers::StandardRouteHandler, DataFlow::ValueNode {
    Function function;

    RouteHandler() {
      function = astNode and
      any(RouteSetup setup).getARouteHandler() = this
    }

    /**
     * Gets the parameter of the route handler that contains the request object.
     */
    Parameter getRequestParameter() { result = function.getParameter(0) }

    /**
     * Gets the parameter of the route handler that contains the response object.
     */
    Parameter getResponseParameter() { result = function.getParameter(1) }
  }

  /**
   * A Restify response source, that is, the response parameter of a
   * route handler.
   */
  private class ResponseSource extends Http::Servers::ResponseSource {
    RouteHandler rh;

    ResponseSource() { this = DataFlow::parameterNode(rh.getResponseParameter()) }

    /**
     * Gets the route handler that provides this response.
     */
    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A Restify request source, that is, the request parameter of a
   * route handler.
   */
  private class RequestSource extends Http::Servers::RequestSource {
    RouteHandler rh;

    RequestSource() { this = DataFlow::parameterNode(rh.getRequestParameter()) }

    /**
     * Gets the route handler that handles this request.
     */
    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * DEPRECATED: Use `ResponseNode` instead.
   * A Node.js HTTP response provided by Restify.
   */
  deprecated class ResponseExpr extends NodeJSLib::ResponseExpr {
    ResponseExpr() { src instanceof ResponseSource }
  }

  /**
   * A Node.js HTTP response provided by Restify.
   */
  class ResponseNode extends NodeJSLib::ResponseNode {
    ResponseNode() { src instanceof ResponseSource }
  }

  /**
   * DEPRECATED: Use `RequestNode` instead.
   * A Node.js HTTP request provided by Restify.
   */
  deprecated class RequestExpr extends NodeJSLib::RequestExpr {
    RequestExpr() { src instanceof RequestSource }
  }

  /**
   * A Node.js HTTP request provided by Restify.
   */
  class RequestNode extends NodeJSLib::RequestNode {
    RequestNode() { src instanceof RequestSource }
  }

  /**
   * An access to a user-controlled Restify request input.
   */
  private class RequestInputAccess extends Http::RequestInputAccess {
    RequestNode request;
    string kind;

    RequestInputAccess() {
      exists(DataFlow::MethodCallNode query |
        // `request.getQuery().<name>`
        kind = "parameter" and
        query.calls(request, "getQuery") and
        this.(DataFlow::PropRead).accesses(query, _)
      )
      or
      exists(string methodName |
        // `request.href()` or `request.getPath()`
        kind = "url" and
        this.(DataFlow::MethodCallNode).calls(request, methodName)
      |
        methodName = "href" or
        methodName = "getPath"
      )
      or
      // `request.getContentType()`, `request.userAgent()`, `request.trailer(...)`, `request.header(...)`
      kind = "header" and
      this.(DataFlow::MethodCallNode)
          .calls(request, ["getContentType", "userAgent", "trailer", "header"])
      or
      // `req.cookies
      kind = "cookie" and
      this.(DataFlow::PropRead).accesses(request, "cookies")
    }

    override RouteHandler getRouteHandler() { result = request.getRouteHandler() }

    override string getKind() { result = kind }
  }

  /**
   * An HTTP header defined in a Restify server.
   */
  private class HeaderDefinition extends Http::Servers::StandardHeaderDefinition {
    HeaderDefinition() {
      // response.header('Cache-Control', 'no-cache')
      this.getReceiver() instanceof ResponseNode and
      this.getMethodName() = "header"
    }

    override RouteHandler getRouteHandler() { this.getReceiver() = result.getAResponseNode() }
  }

  /**
   * A call to a Restify method that sets up a route.
   */
  class RouteSetup extends DataFlow::MethodCallNode, Http::Servers::StandardRouteSetup {
    ServerDefinition server;

    RouteSetup() {
      // server.get('/', fun)
      // server.head('/', fun)
      server.ref().getAMethodCall(any(Http::RequestMethodName m).toLowerCase()) = this
    }

    override DataFlow::SourceNode getARouteHandler() { result.flowsTo(this.getArgument(1)) }

    override DataFlow::Node getServer() { result = server }
  }
}
