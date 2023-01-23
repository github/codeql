/** Provides modeling for the Sinatra library. */

private import codeql.ruby.controlflow.CfgNodes::ExprNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.Concepts

/** Provides modeling for the Sinatra library. */
module Sinatra {
  private class App extends DataFlow::ClassNode {
    App() { this = DataFlow::getConstant("Sinatra").getConstant("Base").getADescendentModule() }

    Route getRoute() { result.getApp() = this }
  }

  private class Route extends DataFlow::CallNode {
    private App app;

    Route() {
      this =
        app.getAModuleLevelCall([
            "get", "post", "put", "patch", "delete", "options", "link", "unlink"
          ])
    }

    App getApp() { result = app }

    DataFlow::BlockNode getBody() { result = this.getBlock() }
  }

  private class Params extends DataFlow::CallNode, Http::Server::RequestInputAccess::Range {
    private Route route;

    Params() {
      this.asExpr().getExpr().getEnclosingCallable() = route.getBody().asCallableAstNode() and
      this.getMethodName() = "params"
    }

    override string getSourceType() { result = "Sinatra::Base#params" }

    override Http::Server::RequestInputKind getKind() {
      result = Http::Server::parameterInputKind()
    }
  }
}
