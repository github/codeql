/**
 * Provides classes for working with [Hapi](https://hapijs.com/) servers.
 */

import javascript
import semmle.javascript.frameworks.HTTP
private import semmle.javascript.dataflow.internal.CallGraphs

module Hapi {
  /**
   * An expression that creates a new Hapi server.
   */
  class ServerDefinition extends Http::Servers::StandardServerDefinition, DataFlow::Node {
    ServerDefinition() {
      // `server = new Hapi.Server()`, `server = Hapi.server()`
      this = DataFlow::moduleMember(["hapi", "@hapi/hapi"], ["Server", "server"]).getAnInvocation()
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

  private DataFlow::SourceNode requestInputRef(
    RouteHandler rh, string property, DataFlow::TypeTracker t
  ) {
    t.start() and
    result = rh.getRequestParameter().getAPropertyRead(property)
    or
    exists(DataFlow::TypeTracker t2 | result = requestInputRef(rh, property, t2).track(t2, t))
  }

  private DataFlow::SourceNode requestInputRef(RouteHandler rh, string property) {
    result = requestInputRef(rh, property, DataFlow::TypeTracker::end())
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
          // `request.payload` is an object, so prefer a property read if possible.
          if exists(requestInputRef(rh, "payload").getAPropertyRead())
          then this = requestInputRef(rh, "payload").getAPropertyRead()
          else this = rh.getRequestParameter().getAPropertyRead("payload")
        )
        or
        kind = "parameter" and
        exists(string property | property = ["query", "params"] |
          // These are objects, so prefer a property read if possible.
          if exists(requestInputRef(rh, property).getAPropertyRead())
          then this = requestInputRef(rh, property).getAPropertyRead()
          else this = rh.getRequestParameter().getAPropertyRead(property)
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

    RouteSetup() {
      server.ref().getAMethodCall() = this and
      this.getMethodName() = ["route", "ext"]
    }

    override DataFlow::SourceNode getARouteHandler() {
      result = this.getARouteHandler(DataFlow::TypeBackTracker::end())
    }

    private DataFlow::SourceNode getARouteHandler(DataFlow::TypeBackTracker t) {
      t.start() and
      result = this.getRouteHandler().getALocalSource()
      or
      this.getMethodName() = "route" and
      t.isInProp("handler") and
      result = this.getArgument(0).getALocalSource()
      or
      exists(DataFlow::TypeBackTracker t2, DataFlow::SourceNode succ |
        succ = this.getARouteHandler(t2)
      |
        result = succ.backtrack(t2, t)
        or
        Http::routeHandlerStep(result, succ) and
        t = t2
        or
        DataFlow::SharedFlowStep::storeStep(result.getALocalUse(), succ,
          DataFlow::PseudoProperties::arrayElement()) and
        t = t2.continue()
      )
    }

    pragma[noinline]
    private DataFlow::Node getRouteHandler() {
      // server.route({ handler: fun })
      this.getMethodName() = "route" and
      this.getOptionArgument(0, "handler") = result
      or
      // server.ext('/', fun)
      this.getMethodName() = "ext" and
      result = this.getArgument(1)
      or
      // server.route([{ handler(request){}])
      this.getMethodName() = "route" and
      result =
        this.getArgument(0)
            .getALocalSource()
            .(DataFlow::ArrayCreationNode)
            .getAnElement()
            .getALocalSource()
            .getAPropertySource("handler")
            .getAFunctionValue()
    }

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

  private DataFlow::SourceNode routeDefinitionRef(
    DataFlow::ObjectLiteralNode definition, DataFlow::TypeTracker t
  ) {
    t.start() and
    result = definition
    or
    exists(DataFlow::TypeTracker t2 | result = routeDefinitionRef(definition, t2).track(t2, t))
  }

  private predicate handlerRegistration(
    DataFlow::FunctionNode handler, DataFlow::ObjectLiteralNode definition
  ) {
    exists(
      DataFlow::CallNode registration, DataFlow::FunctionNode registrar,
      DataFlow::ParameterNode handlerParameter, DataFlow::SourceNode handlerRef, int index
    |
      registration.getACallee() = registrar.getFunction() and
      handlerParameter = registrar.getParameter(index) and
      handlerParameter.flowsTo(definition.getAPropertyWrite("handler").getRhs()) and
      (
        handlerRef = handler
        or
        handlerRef = CallGraph::callgraphStep(handler, DataFlow::TypeTracker::end())
      ) and
      handlerRef.flowsTo(registration.getArgument(index))
    )
  }

  /** Data flow through handlers stored in route definitions by registration helpers. */
  private class RegisteredHandlerCallStep extends DataFlow::SharedFlowStep {
    DataFlow::CallNode call;
    DataFlow::FunctionNode handler;

    RegisteredHandlerCallStep() {
      exists(DataFlow::ObjectLiteralNode definition, DataFlow::PropRead handlerRead |
        handlerRegistration(handler, definition) and
        handlerRead.getPropertyName() = "handler" and
        routeDefinitionRef(definition, DataFlow::TypeTracker::end()).flowsTo(handlerRead.getBase()) and
        call.getCalleeNode() = handlerRead
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(int index |
        pred = call.getArgument(index) and
        succ = handler.getParameter(index)
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
