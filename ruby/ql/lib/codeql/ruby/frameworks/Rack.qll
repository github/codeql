/**
 * Provides modeling for the Rack library.
 */

private import codeql.ruby.controlflow.CfgNodes::ExprNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.typetracking.TypeTracker

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
      call.getReturn() = trackRackResponse()
    }

    /**
     * Gets the environment of the request, which is the lone parameter to the `call` method.
     */
    DataFlow::ParameterNode getEnv() { result = call.getParameter(0) }
  }

  private DataFlow::LocalSourceNode trackStatusCode(TypeTracker t, int i) {
    t.start() and
    result.getConstantValue().isInt(i)
    or
    exists(TypeTracker t2 | result = trackStatusCode(t2, i).track(t2, t))
  }

  private DataFlow::Node trackStatusCode(int i) {
    trackStatusCode(TypeTracker::end(), i).flowsTo(result)
  }

  class ResponseNode extends DataFlow::ArrayLiteralNode {
    // [status, headers, body]
    ResponseNode() { this.getNumberOfArguments() = 3 }

    /**
     * Gets an HTTP status code that may be returned in this response.
     */
    int getAStatusCode() { this.getElement(0) = trackStatusCode(result) }
  }

  private DataFlow::LocalSourceNode trackRackResponse(TypeTracker t) {
    t.start() and
    result instanceof ResponseNode
    or
    exists(TypeTracker t2 | result = trackRackResponse(t2).track(t2, t))
  }

  private DataFlow::Node trackRackResponse() {
    trackRackResponse(TypeTracker::end()).flowsTo(result)
  }
}
