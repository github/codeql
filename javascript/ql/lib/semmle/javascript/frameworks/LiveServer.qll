/**
 * Provides classes modeling the [live-server](https://npmjs.com/package/live-server) package.
 */

import javascript
private import semmle.javascript.frameworks.ConnectExpressShared::ConnectExpressShared as ConnectExpressShared

private module LiveServer {
  /**
   * An expression that imports the live-server package, seen as a server-definition.
   */
  class ServerDefinition extends Http::Servers::StandardServerDefinition {
    ServerDefinition() { this = DataFlow::moduleImport("live-server") }

    API::Node getImportNode() { result.asSource() = this }
  }

  /**
   * A live-server middleware definition.
   * `live-server` uses the `connect` library under the hood, so the model is based on the `connect` model.
   */
  class RouteHandler extends Connect::RouteHandler, DataFlow::FunctionNode {
    RouteHandler() { this = any(RouteSetup setup).getARouteHandler() }

    override DataFlow::ParameterNode getRouteHandlerParameter(string kind) {
      result = ConnectExpressShared::getRouteHandlerParameter(this, kind)
    }
  }

  /**
   * The call to `require("live-server").start()`, seen as a route setup.
   */
  class RouteSetup extends Http::Servers::StandardRouteSetup instanceof API::CallNode {
    ServerDefinition server;

    RouteSetup() { this = server.getImportNode().getMember("start").getACall() }

    override DataFlow::SourceNode getARouteHandler() {
      exists(DataFlow::SourceNode middleware |
        middleware = super.getParameter(0).getMember("middleware").getAValueReachingSink()
      |
        result = middleware.getAMemberCall(["push", "unshift"]).getArgument(0).getAFunctionValue()
        or
        result = middleware.(DataFlow::ArrayCreationNode).getAnElement().getAFunctionValue()
      )
    }

    override DataFlow::Node getServer() { result = server }
  }
}
