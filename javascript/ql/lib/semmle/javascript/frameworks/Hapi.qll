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
    Parameter getRequestParameter() { result = function.getParameter(0) }

    /**
     * Gets the parameter of the route handler that contains the "request toolkit",
     * usually named `h`.
     */
    Parameter getRequestToolkitParameter() { result = function.getParameter(1) }

    /**
     * Gets a source node referring to the request toolkit parameter, usually named `h`.
     */
    DataFlow::SourceNode getRequestToolkit() { result = getRequestToolkitParameter().flow() }
  }

  /**
   * A Hapi response source, that is, an access to the `response` property
   * of a request object.
   */
  private class ResponseSource extends HTTP::Servers::ResponseSource {
    RequestExpr req;

    ResponseSource() { asExpr().(PropAccess).accesses(req, "response") }

    /**
     * Gets the route handler that provides this response.
     */
    override RouteHandler getRouteHandler() { result = req.getRouteHandler() }
  }

  /**
   * A Hapi request source, that is, the request parameter of a
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
      exists(Expr request | request = rh.getARequestExpr() |
        kind = "body" and
        (
          // `request.rawPayload`
          this.asExpr().(PropAccess).accesses(request, "rawPayload")
          or
          exists(PropAccess payload |
            // `request.payload.name`
            payload.accesses(request, "payload") and
            this.asExpr().(PropAccess).accesses(payload, _)
          )
        )
        or
        kind = "parameter" and
        exists(PropAccess query |
          // `request.query.name`
          query.accesses(request, "query") and
          this.asExpr().(PropAccess).accesses(query, _)
        )
        or
        exists(PropAccess url |
          // `request.url.path`
          kind = "url" and
          url.accesses(request, "url") and
          this.asExpr().(PropAccess).accesses(url, "path")
        )
        or
        exists(PropAccess state |
          // `request.state.<name>`
          kind = "cookie" and
          state.accesses(request, "state") and
          this.asExpr().(PropAccess).accesses(state, _)
        )
      )
      or
      exists(RequestHeaderAccess access | this = access |
        rh = access.getRouteHandler() and
        kind = "header"
      )
    }

    override RouteHandler getRouteHandler() { result = rh }

    override string getKind() { result = kind }
  }

  /**
   * An access to an HTTP header on a Hapi request.
   */
  private class RequestHeaderAccess extends HTTP::RequestHeaderAccess {
    RouteHandler rh;

    RequestHeaderAccess() {
      exists(Expr request | request = rh.getARequestExpr() |
        exists(PropAccess headers |
          // `request.headers.<name>`
          headers.accesses(request, "headers") and
          this.asExpr().(PropAccess).accesses(headers, _)
        )
      )
    }

    override string getAHeaderName() {
      result = this.(DataFlow::PropRead).getPropertyName().toLowerCase()
    }

    override RouteHandler getRouteHandler() { result = rh }

    override string getKind() { result = "header" }
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

    override RouteHandler getRouteHandler() { result = res.getRouteHandler() }
  }

  /**
   * A call to a Hapi method that sets up a route.
   */
  class RouteSetup extends MethodCallExpr, HTTP::Servers::StandardRouteSetup {
    ServerDefinition server;
    Expr handler;

    RouteSetup() {
      server.flowsTo(getReceiver()) and
      (
        // server.route({ handler: fun })
        getMethodName() = "route" and
        hasOptionArgument(0, "handler", handler)
        or
        // server.ext('/', fun)
        getMethodName() = "ext" and
        handler = getArgument(1)
      )
    }

    override DataFlow::SourceNode getARouteHandler() {
      result = getARouteHandler(DataFlow::TypeBackTracker::end())
    }

    private DataFlow::SourceNode getARouteHandler(DataFlow::TypeBackTracker t) {
      t.start() and
      result = getRouteHandler().getALocalSource()
      or
      exists(DataFlow::TypeBackTracker t2 | result = getARouteHandler(t2).backtrack(t2, t))
    }

    pragma[noinline]
    private DataFlow::Node getRouteHandler() { result = handler.flow() }

    Expr getRouteHandlerExpr() { result = handler }

    override Expr getServer() { result = server }
  }

  /**
   * A function that looks like a Hapi route handler.
   *
   * For example, this could be the function `function(request, h){...}`.
   */
  class RouteHandlerCandidate extends HTTP::RouteHandlerCandidate {
    RouteHandlerCandidate() {
      exists(string request, string responseToolkit |
        (request = "request" or request = "req") and
        responseToolkit = "h" and
        // heuristic: parameter names match the Hapi documentation
        astNode.getNumParameter() = 2 and
        astNode.getParameter(0).getName() = request and
        astNode.getParameter(1).getName() = responseToolkit
      |
        // heuristic: is not invoked (Hapi invokes this at a call site we cannot reason precisely about)
        not exists(DataFlow::InvokeNode cs | cs.getACallee() = astNode)
      )
    }
  }

  /**
   * A function that looks like a Hapi route handler and flows to a route setup.
   */
  private class TrackedRouteHandlerCandidateWithSetup extends RouteHandler,
    HTTP::Servers::StandardRouteHandler, DataFlow::FunctionNode {
    TrackedRouteHandlerCandidateWithSetup() { this = any(RouteSetup s).getARouteHandler() }
  }

  /**
   * A call to `h.view('file', { ... })` seen as a template instantiation.
   */
  private class ViewCall extends Templating::TemplateInstantiation::Range, DataFlow::CallNode {
    ViewCall() { this = any(RouteHandler rh).getRequestToolkit().getAMethodCall("view") }

    override DataFlow::SourceNode getOutput() { none() }

    override DataFlow::Node getTemplateFileNode() { result = getArgument(0) }

    override DataFlow::Node getTemplateParamsNode() { result = getArgument(1) }
  }

  /**
   * A return from a route handler.
   */
  private class HandlerReturn extends HTTP::ResponseSendArgument {
    RouteHandler handler;

    HandlerReturn() { this = handler.(DataFlow::FunctionNode).getAReturn().asExpr() }

    override RouteHandler getRouteHandler() { result = handler }
  }
}
