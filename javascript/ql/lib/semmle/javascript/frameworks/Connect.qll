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
  class ServerDefinition extends Http::Servers::StandardServerDefinition, DataFlow::CallNode {
    ServerDefinition() {
      // `app = connect()`
      this = DataFlow::moduleImport("connect").getAnInvocation()
    }
  }

  /**
   * A function used as a Connect route handler.
   *
   * By default, only handlers installed by an Connect route setup are recognized,
   * but support for other kinds of route handlers can be added by implementing
   * additional subclasses of this class.
   */
  abstract class RouteHandler extends NodeJSLib::RouteHandler, DataFlow::ValueNode {
    /**
     * Gets the parameter of kind `kind` of this route handler.
     *
     * `kind` is one of: "error", "request", "response", "next".
     */
    abstract DataFlow::ParameterNode getRouteHandlerParameter(string kind);

    /**
     * Gets the parameter of the route handler that contains the request object.
     */
    override DataFlow::ParameterNode getRequestParameter() {
      result = this.getRouteHandlerParameter("request")
    }

    /**
     * Gets the parameter of the route handler that contains the response object.
     */
    override DataFlow::ParameterNode getResponseParameter() {
      result = this.getRouteHandlerParameter("response")
    }
  }

  /**
   * A Connect route handler installed by a route setup.
   */
  class StandardRouteHandler extends RouteHandler, DataFlow::FunctionNode {
    StandardRouteHandler() { this = any(RouteSetup setup).getARouteHandler() }

    override DataFlow::ParameterNode getRouteHandlerParameter(string kind) {
      result = getRouteHandlerParameter(this, kind)
    }
  }

  /**
   * A call to a Connect method that sets up a route.
   */
  class RouteSetup extends DataFlow::MethodCallNode, Http::Servers::StandardRouteSetup {
    ServerDefinition server;

    RouteSetup() {
      this.getMethodName() = "use" and
      (
        // app.use(fun)
        server.ref().getAMethodCall() = this
        or
        // app.use(...).use(fun)
        this.getReceiver().(RouteSetup).getServer() = server
      )
    }

    override DataFlow::SourceNode getARouteHandler() {
      result = this.getARouteHandler(DataFlow::TypeBackTracker::end())
    }

    private DataFlow::SourceNode getARouteHandler(DataFlow::TypeBackTracker t) {
      t.start() and
      result = this.getARouteHandlerNode().getALocalSource()
      or
      exists(DataFlow::TypeBackTracker t2 | result = this.getARouteHandler(t2).backtrack(t2, t))
    }

    override DataFlow::Node getServer() { result = server }

    /**
     * Gets an argument that represents a route handler being registered.
     */
    DataFlow::Node getARouteHandlerNode() { result = this.getAnArgument() }
  }

  /** An expression that is passed as `basicAuthConnect(<user>, <password>)`. */
  class Credentials extends CredentialsNode {
    string kind;

    Credentials() {
      exists(DataFlow::CallNode call |
        call = DataFlow::moduleImport("basic-auth-connect").getAnInvocation() and
        call.getNumArgument() = 2
      |
        this = call.getArgument(0) and kind = "user name"
        or
        this = call.getArgument(1) and kind = "password"
      )
    }

    override string getCredentialsKind() { result = kind }
  }

  class RequestNode = NodeJSLib::RequestNode;

  /**
   * An access to a user-controlled Connect request input.
   */
  private class RequestInputAccess extends Http::RequestInputAccess instanceof DataFlow::MethodCallNode
  {
    RequestNode request;
    string kind;

    RequestInputAccess() {
      request.getRouteHandler() instanceof StandardRouteHandler and
      exists(DataFlow::PropRead cookies |
        // `req.cookies.get(<name>)`
        kind = "cookie" and
        cookies.accesses(request, "cookies") and
        super.calls(cookies, "get")
      )
    }

    override RouteHandler getRouteHandler() { result = request.getRouteHandler() }

    override string getKind() { result = kind }
  }
}
