/**
 * Provides modeling for the Rack library.
 */

private import codeql.ruby.controlflow.CfgNodes::ExprNodes
private import codeql.ruby.DataFlow

/**
 * Provides modeling for the Rack library.
 */
module Rack {
  /**
   * A class that may be a rack application.
   * This is a class that has a `call` method that takes a single argument
   * (traditionally called `env`) and returns a rack-compatible response.
   */
  class AppCandidate extends DataFlow::ClassNode {
    private DataFlow::MethodNode call;

    AppCandidate() {
      call = this.getInstanceMethod("call") and
      call.getNumberOfParameters() = 1 and
      exists(DataFlow::LocalSourceNode resp | isRackResponse(resp) | resp.flowsTo(call.getReturn()))
    }

    /**
     * Gets the environment of the request, which is the lone parameter to the `call` method.
     */
    DataFlow::ParameterNode getEnv() { result = call.getParameter(0) }
  }

  private predicate isRackResponse(DataFlow::Node r) {
    // [status, headers, body]
    exists(ArrayLiteralCfgNode arr | arr.getNumberOfArguments() = 3 |
      r.asExpr() = arr
      or
      exists(DataFlow::LocalSourceNode n | n.asExpr() = arr | n.flowsTo(r))
    )
  }
}
