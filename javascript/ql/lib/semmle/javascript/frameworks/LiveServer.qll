/**
 * Provides classes modeling the [live-server](https://npmjs.com/package/live-server) package.
 */

import javascript
private import semmle.javascript.frameworks.ConnectExpressShared::ConnectExpressShared as ConnectExpressShared

private module LiveServer {
  /**
   * An expression that imports the live-server package, seen as a server-definition.
   */
  class ServerDefinition extends HTTP::Servers::StandardServerDefinition {
    ServerDefinition() { this = DataFlow::moduleImport("live-server").asExpr() }

    API::Node getImportNode() { result.getAnImmediateUse().asExpr() = this }
  }

  /**
   * A live-server middleware definition.
   * `live-server` uses the `connect` library under the hood, so the model is based on the `connect` model.
   */
  class RouteHandler extends Connect::RouteHandler, DataFlow::FunctionNode {
    RouteHandler() { this = any(RouteSetup setup).getARouteHandler() }

    override Parameter getRouteHandlerParameter(string kind) {
      result = ConnectExpressShared::getRouteHandlerParameter(astNode, kind)
    }
  }

  /**
   * The call to `require("live-server").start()`, seen as a route setup.
   */
  class RouteSetup extends MethodCallExpr, HTTP::Servers::StandardRouteSetup {
    ServerDefinition server;
    API::CallNode call;

    RouteSetup() {
      call = server.getImportNode().getMember("start").getACall() and
      this = call.asExpr()
    }

    override DataFlow::SourceNode getARouteHandler() {
      exists(DataFlow::SourceNode middleware |
        middleware = call.getParameter(0).getMember("middleware").getAValueReachingRhs()
      |
        result = middleware.getAMemberCall(["push", "unshift"]).getArgument(0).getAFunctionValue()
        or
        result = middleware.(DataFlow::ArrayCreationNode).getAnElement().getAFunctionValue()
      )
    }

    override Expr getServer() { result = server }
  }
}
