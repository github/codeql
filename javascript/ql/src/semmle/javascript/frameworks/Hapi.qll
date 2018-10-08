/**
 * Provides classes for working with [Hapi](https://hapijs.com/) servers.
 */
import javascript
import semmle.javascript.frameworks.HTTP

module Hapi {
  /**
   * An expression that creates a new Hapi server.
   */
  class ServerDefinition extends HTTP::Servers::StandardServerDefinition, NewExpr {
    ServerDefinition() {
      // `server = new Hapi.Server()`
      this = DataFlow::moduleMember("hapi", "Server").getAnInstantiation().asExpr()
    }
  }

  /**
   * A Hapi route handler.
   */
  class RouteHandler extends HTTP::Servers::StandardRouteHandler, DataFlow::ValueNode {

    Function function;

    RouteHandler() {
      function = astNode and
      exists(RouteSetup setup | this = setup.getARouteHandler())
    }

    /**
     * Gets the parameter of the route handler that contains the request object.
     */
    SimpleParameter getRequestParameter() {
      result = function.getParameter(0)
    }
  }

  /**
   * A Hapi response source, that is, an access to the `response` property
   * of a request object.
   */
  private class ResponseSource extends HTTP::Servers::ResponseSource {
    RequestExpr req;

    ResponseSource() {
      asExpr().(PropAccess).accesses(req, "response")
    }

    /**
     * Gets the route handler that provides this response.
     */
    override RouteHandler getRouteHandler() {
      result = req.getRouteHandler()
    }
  }

  /**
   * A Hapi request source, that is, the request parameter of a
   * route handler.
   */
  private class RequestSource extends HTTP::Servers::RequestSource {
    RouteHandler rh;

    RequestSource() {
      this = DataFlow::parameterNode(rh.getRequestParameter())
    }

    /**
     * Gets the route handler that handles this request.
     */
    override RouteHandler getRouteHandler() {
      result = rh
    }
  }

  /**
   * A Hapi response expression.
   */
  class ResponseExpr extends HTTP::Servers::StandardResponseExpr {
    override ResponseSource src;
  }

  /**
   * An Hapi request expression.
   */
  class RequestExpr extends HTTP::Servers::StandardRequestExpr {
    override RequestSource src;
  }

  /**
   * An access to a user-controlled Hapi request input.
   */
  private class RequestInputAccess extends HTTP::RequestInputAccess {
    RouteHandler rh;
    string kind;

    RequestInputAccess() {
      exists (Expr request | request = rh.getARequestExpr() |
        kind = "body" and
        (
          // `request.rawPayload`
          this.asExpr().(PropAccess).accesses(request, "rawPayload") or
          exists (PropAccess payload |
            // `request.payload.name`
            payload.accesses(request, "payload")  and
            this.asExpr().(PropAccess).accesses(payload, _)
          )
        )
        or
        kind = "parameter" and
        exists (PropAccess query |
          // `request.query.name`
          query.accesses(request, "query")  and
          this.asExpr().(PropAccess).accesses(query, _)
        )
        or
        exists (PropAccess url |
          // `request.url.path`
          kind = "url" and
          url.accesses(request, "url")  and
          this.asExpr().(PropAccess).accesses(url, "path")
        )
        or
        exists (PropAccess state |
          // `request.state.<name>`
          kind = "cookie" and
          state.accesses(request, "state")  and
          this.asExpr().(PropAccess).accesses(state, _)
        )
      )
      or
      exists (RequestHeaderAccess access | this = access |
        rh = access.getRouteHandler() and
        kind = "header")
    }

    override RouteHandler getRouteHandler() {
      result = rh
    }

    override string getKind() {
      result = kind
    }
  }

  /**
   * An access to an HTTP header on a Hapi request.
   */
  private class RequestHeaderAccess extends HTTP::RequestHeaderAccess {
    RouteHandler rh;

    RequestHeaderAccess() {
      exists (Expr request | request = rh.getARequestExpr() |
        exists (PropAccess headers |
          // `request.headers.<name>`
          headers.accesses(request, "headers")  and
          this.asExpr().(PropAccess).accesses(headers, _)
        )
      )
    }

    override string getAHeaderName() {
      result = this.(DataFlow::PropRead).getPropertyName().toLowerCase()
    }

    override RouteHandler getRouteHandler() {
      result = rh
    }

    override string getKind() {
      result = "header"
    }
  }

  /**
   * An HTTP header defined in a Hapi server.
   */
  private class HeaderDefinition extends HTTP::Servers::StandardHeaderDefinition {
    ResponseExpr res;

    HeaderDefinition() {
      // request.response.header('Cache-Control', 'no-cache')
      astNode.calls(res, "header")
    }

    override RouteHandler getRouteHandler(){
      result = res.getRouteHandler()
    }

  }

  /**
   * A call to a Hapi method that sets up a route.
   */
  class RouteSetup extends MethodCallExpr, HTTP::Servers::StandardRouteSetup {
    ServerDefinition server;
    string methodName;

    RouteSetup() {
      server.flowsTo(getReceiver()) and
      methodName = getMethodName() and
      (methodName = "route" or methodName = "ext")
    }

    override DataFlow::SourceNode getARouteHandler() {
      // server.route({ handler: fun })
      methodName = "route" and
      result.flowsToExpr(any(Expr e | hasOptionArgument(0, "handler", e)))
      or
      // server.ext('/', fun)
      methodName = "ext" and
      result.flowsToExpr(getArgument(1))
    }

    override Expr getServer() {
      result = server
    }
  }
}
