/**
 * Provides classes for working with [Connect](https://github.com/senchalabs/connect) applications.
 */

import javascript
import semmle.javascript.frameworks.HTTP
private import semmle.javascript.frameworks.ConnectExpressShared::ConnectExpressShared

module Connect {
  /**
   * An expression that creates a new Connect server.
   */
  class ServerDefinition extends HTTP::Servers::StandardServerDefinition, CallExpr {
    ServerDefinition() {
      // `app = connect()`
      this = DataFlow::moduleImport("connect").getAnInvocation().asExpr()
    }
  }

  /**
   * A function used as a Connect route handler.
   *
   * By default, only handlers installed by an Connect route setup are recognized,
   * but support for other kinds of route handlers can be added by implementing
   * additional subclasses of this class.
   */
  abstract class RouteHandler extends HTTP::Servers::StandardRouteHandler, DataFlow::ValueNode {
    /**
     * Gets the parameter of kind `kind` of this route handler.
     *
     * `kind` is one of: "error", "request", "response", "next".
     */
    abstract Parameter getRouteHandlerParameter(string kind);

    /**
     * Gets the parameter of the route handler that contains the request object.
     */
    Parameter getRequestParameter() { result = getRouteHandlerParameter("request") }

    /**
     * Gets the parameter of the route handler that contains the response object.
     */
    Parameter getResponseParameter() { result = getRouteHandlerParameter("response") }
  }

  /**
   * A Connect route handler installed by a route setup.
   */
  class StandardRouteHandler extends RouteHandler {
    override Function astNode;

    StandardRouteHandler() { this = any(RouteSetup setup).getARouteHandler() }

    override Parameter getRouteHandlerParameter(string kind) {
      result = getRouteHandlerParameter(astNode, kind)
    }
  }

  /**
   * A Connect response source, that is, the response parameter of a
   * route handler.
   */
  private class ResponseSource extends HTTP::Servers::ResponseSource {
    RouteHandler rh;

    ResponseSource() { this = DataFlow::parameterNode(rh.getResponseParameter()) }

    /**
     * Gets the route handler that provides this response.
     */
    override RouteHandler getRouteHandler() { result = rh }
  }

  /**
   * A Connect request source, that is, the request parameter of a
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
   * A Node.js HTTP response provided by Connect.
   */
  class ResponseExpr extends NodeJSLib::ResponseExpr {
    ResponseExpr() { src instanceof ResponseSource }
  }

  /**
   * A Node.js HTTP request provided by Connect.
   */
  class RequestExpr extends NodeJSLib::RequestExpr {
    RequestExpr() { src instanceof RequestSource }
  }

  /**
   * A call to a Connect method that sets up a route.
   */
  class RouteSetup extends MethodCallExpr, HTTP::Servers::StandardRouteSetup {
    ServerDefinition server;

    RouteSetup() {
      getMethodName() = "use" and
      (
        // app.use(fun)
        server.flowsTo(getReceiver())
        or
        // app.use(...).use(fun)
        this.getReceiver().(RouteSetup).getServer() = server
      )
    }

    override DataFlow::SourceNode getARouteHandler() {
      result = getARouteHandler(DataFlow::TypeBackTracker::end())
    }

    private DataFlow::SourceNode getARouteHandler(DataFlow::TypeBackTracker t) {
      t.start() and
      result = getARouteHandlerExpr().flow().getALocalSource()
      or
      exists(DataFlow::TypeBackTracker t2 | result = getARouteHandler(t2).backtrack(t2, t))
    }

    override Expr getServer() { result = server }

    /** Gets an argument that represents a route handler being registered. */
    Expr getARouteHandlerExpr() { result = getAnArgument() }
  }

  /** An expression that is passed as `basicAuthConnect(<user>, <password>)`. */
  class Credentials extends CredentialsExpr {
    string kind;

    Credentials() {
      exists(CallExpr call |
        call = DataFlow::moduleImport("basic-auth-connect").getAnInvocation().asExpr() and
        call.getNumArgument() = 2
      |
        this = call.getArgument(0) and kind = "user name"
        or
        this = call.getArgument(1) and kind = "password"
      )
    }

    override string getCredentialsKind() { result = kind }
  }

  /**
   * An access to a user-controlled Connect request input.
   */
  private class RequestInputAccess extends HTTP::RequestInputAccess {
    RequestExpr request;
    string kind;

    RequestInputAccess() {
      exists(PropAccess cookies |
        // `req.cookies.get(<name>)`
        kind = "cookie" and
        cookies.accesses(request, "cookies") and
        this.asExpr().(MethodCallExpr).calls(cookies, "get")
      )
    }

    override RouteHandler getRouteHandler() { result = request.getRouteHandler() }

    override string getKind() { result = kind }
  }

  /**
   * A function that flows to a route setup.
   */
  private class TrackedRouteHandlerCandidateWithSetup extends RouteHandler,
    HTTP::Servers::StandardRouteHandler, DataFlow::FunctionNode {
    TrackedRouteHandlerCandidateWithSetup() { this = any(RouteSetup s).getARouteHandler() }

    override Parameter getRouteHandlerParameter(string kind) {
      result = getRouteHandlerParameter(astNode, kind)
    }
  }

  /**
   * A call that looks like a route setup on a Connect server.
   *
   * For example, this could be the call `router.use(handler)` where
   * it is unknown if `router` is a Connect router.
   */
  class RouteSetupCandidate extends HTTP::RouteSetupCandidate, DataFlow::MethodCallNode {
    DataFlow::ValueNode routeHandlerArg;

    RouteSetupCandidate() {
      getMethodName() = "use" and
      routeHandlerArg = getAnArgument()
    }

    override DataFlow::ValueNode getARouteHandlerArg() { result = routeHandlerArg }
  }
}
