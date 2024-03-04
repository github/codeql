/**
 * Provides classes for working with [Hapi](https://hapijs.com/) servers.
 */

import javascript
import semmle.javascript.frameworks.HTTP

module Hapi {
  /**
   * An expression that creates a new Hapi server.
   */
  class ServerDefinition extends Http::Servers::StandardServerDefinition, DataFlow::Node {
    ServerDefinition() {
      // `server = new Hapi.Server()`
      this = DataFlow::moduleMember("hapi", "Server").getAnInstantiation()
      or
      // `server = Glue.compose(manifest, composeOptions)`
      this = DataFlow::moduleMember("@hapi/glue", "compose").getAnInvocation()
      or
      // `register (server, options)`
      // `module.exports.plugin = {register, pkg};`
      this =
        any(Module m)
            .getAnExportedValue("plugin")
            .getALocalSource()
            .getAPropertySource("register")
            .getAFunctionValue()
            .getParameter(0)
      or
      // `const after = function (server) {...};`
      // `server.dependency('name', after);`
      this =
        any(ServerDefinition s).ref().getAMethodCall("dependency").getABoundCallbackParameter(1, 0)
    }
  }

  /**
   * A Hapi route handler.
   */
  class RouteHandler extends Http::Servers::StandardRouteHandler, DataFlow::FunctionNode {
    RouteHandler() { exists(RouteSetup setup | this = setup.getARouteHandler()) }

    /**
     * Gets the parameter of the route handler that contains the request object.
     */
    DataFlow::ParameterNode getRequestParameter() { result = this.getParameter(0) }

    /**
     * Gets the parameter of the route handler that contains the "request toolkit",
     * usually named `h`.
     */
    DataFlow::ParameterNode getRequestToolkitParameter() { result = this.getParameter(1) }

    /**
     * Gets a source node referring to the request toolkit parameter, usually named `h`.
     */
    DataFlow::SourceNode getRequestToolkit() { result = this.getRequestToolkitParameter() }
  }

  /**
   * A Hapi response source, that is, an access to the `response` property
   * of a request object.
   */
  private class ResponseSource extends Http::Servers::ResponseSource {
    RequestNode req;

    ResponseSource() { this.(DataFlow::PropRead).accesses(req, "response") }

    /**
     * Gets the route handler that provides this response.
     */
    override RouteHandler getRouteHandler() { result = req.getRouteHandler() }
  }

  /**
   * A Hapi request source, that is, the request parameter of a
   * route handler.
   */
  private class RequestSource extends Http::Servers::RequestSource {
    RouteHandler rh;

    RequestSource() { this = rh.getRequestParameter() }

    /**
     * Gets the route handler that handles this request.
     */
    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A Hapi response node.
   */
  class ResponseNode extends Http::Servers::StandardResponseNode {
    override ResponseSource src;
  }

  /**
   * A Hapi request node.
   */
  class RequestNode extends Http::Servers::StandardRequestNode {
    override RequestSource src;
  }

  /**
   * An access to a user-controlled Hapi request input.
   */
  private class RequestInputAccess extends Http::RequestInputAccess {
    RouteHandler rh;
    string kind;

    RequestInputAccess() {
      exists(DataFlow::Node request | request = rh.getARequestNode() |
        kind = "body" and
        (
          // `request.rawPayload`
          this.(DataFlow::PropRead).accesses(request, "rawPayload")
          or
          exists(DataFlow::PropRead payload |
            // `request.payload.name`
            payload.accesses(request, "payload") and
            this.(DataFlow::PropRead).accesses(payload, _)
          )
        )
        or
        kind = "parameter" and
        exists(DataFlow::PropRead query |
          // `request.query.name`
          query.accesses(request, ["query", "params"]) and
          this.(DataFlow::PropRead).accesses(query, _)
        )
        or
        exists(DataFlow::PropRead url |
          // `request.url.path`
          kind = "url" and
          url.accesses(request, "url") and
          this.(DataFlow::PropRead).accesses(url, ["path", "origin"])
        )
        or
        exists(DataFlow::PropRead state |
          // `request.state.<name>`
          kind = "cookie" and
          state.accesses(request, "state") and
          this.(DataFlow::PropRead).accesses(state, _)
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
  private class RequestHeaderAccess extends Http::RequestHeaderAccess {
    RouteHandler rh;

    RequestHeaderAccess() {
      exists(DataFlow::Node request | request = rh.getARequestNode() |
        exists(DataFlow::PropRead headers |
          // `request.headers.<name>`
          headers.accesses(request, "headers") and
          this.(DataFlow::PropRead).accesses(headers, _)
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
  private class HeaderDefinition extends Http::Servers::StandardHeaderDefinition {
    ResponseNode res;

    HeaderDefinition() {
      // request.response.header('Cache-Control', 'no-cache')
      this.calls(res, "header")
    }

    override RouteHandler getRouteHandler() { result = res.getRouteHandler() }
  }

  /**
   * A call to a Hapi method that sets up a route.
   */
  class RouteSetup extends DataFlow::MethodCallNode, Http::Servers::StandardRouteSetup {
    ServerDefinition server;
    DataFlow::Node handler;

    RouteSetup() {
      server.ref().getAMethodCall() = this and
      (
        // server.route({ handler: fun })
        this.getMethodName() = "route" and
        this.getOptionArgument(0, "handler") = handler
        or
        // server.ext('/', fun)
        this.getMethodName() = "ext" and
        handler = this.getArgument(1)
        or
        // server.route([{ handler(request){}])
        this.getMethodName() = "route" and
        handler =
          this.getArgument(0)
              .getALocalSource()
              .(DataFlow::ArrayCreationNode)
              .getAnElement()
              .getALocalSource()
              .getAPropertySource("handler")
              .getAFunctionValue()
      )
    }

    override DataFlow::SourceNode getARouteHandler() {
      result = this.getARouteHandler(DataFlow::TypeBackTracker::end())
    }

    private DataFlow::SourceNode getARouteHandler(DataFlow::TypeBackTracker t) {
      t.start() and
      result = this.getRouteHandler().getALocalSource()
      or
      exists(DataFlow::TypeBackTracker t2 | result = this.getARouteHandler(t2).backtrack(t2, t))
    }

    pragma[noinline]
    private DataFlow::Node getRouteHandler() { result = handler }

    override DataFlow::Node getServer() { result = server }
  }

  /**
   * A function that looks like a Hapi route handler.
   *
   * For example, this could be the function `function(request, h){...}`.
   */
  class RouteHandlerCandidate extends Http::RouteHandlerCandidate {
    RouteHandlerCandidate() {
      exists(string request, string responseToolkit |
        (request = "request" or request = "req") and
        responseToolkit = ["h", "hapi"] and
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
    Http::Servers::StandardRouteHandler, DataFlow::FunctionNode
  {
    TrackedRouteHandlerCandidateWithSetup() { this = any(RouteSetup s).getARouteHandler() }
  }

  /**
   * A call to `h.view('file', { ... })` seen as a template instantiation.
   */
  private class ViewCall extends Templating::TemplateInstantiation::Range, DataFlow::CallNode {
    ViewCall() { this = any(RouteHandler rh).getRequestToolkit().getAMethodCall("view") }

    override DataFlow::SourceNode getOutput() { none() }

    override DataFlow::Node getTemplateFileNode() { result = this.getArgument(0) }

    override DataFlow::Node getTemplateParamsNode() { result = this.getArgument(1) }
  }

  /**
   * A return from a route handler.
   */
  private class HandlerReturn extends Http::ResponseSendArgument {
    RouteHandler handler;

    HandlerReturn() { this = handler.(DataFlow::FunctionNode).getAReturn() }

    override RouteHandler getRouteHandler() { result = handler }
  }
}
