/**
 * Provides modeling for Rack applications.
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.typetracking.TypeTracker
private import Response::Private as RP

/** A method node for a method named `call`. */
private class CallMethodNode extends DataFlow::MethodNode {
  CallMethodNode() { this.getMethodName() = "call" }
}

private DataFlow::LocalSourceNode trackRackResponse(TypeBackTracker t, CallMethodNode call) {
  t.start() and
  result = call.getAReturnNode()
  or
  exists(TypeBackTracker t2 | result = trackRackResponse(t2, call).backtrack(t2, t))
}

private RP::PotentialResponseNode trackRackResponse(CallMethodNode call) {
  result = trackRackResponse(TypeBackTracker::end(), call)
}

/**
 * Provides modeling for Rack applications.
 */
module App {
  /**
   * A class that may be a rack application.
   * This is a class that has a `call` method that takes a single argument
   * (traditionally called `env`) and returns a rack-compatible response.
   */
  class AppCandidate extends DataFlow::ClassNode {
    private CallMethodNode call;
    private RP::PotentialResponseNode resp;

    AppCandidate() {
      call = this.getInstanceMethod("call") and
      call.getNumberOfParameters() = 1 and
      resp = trackRackResponse(call)
    }

    /**
     * Gets the environment of the request, which is the lone parameter to the `call` method.
     */
    DataFlow::ParameterNode getEnv() { result = call.getParameter(0) }

    /** Gets the response returned from a request to this application. */
    RP::PotentialResponseNode getResponse() { result = resp }
  }
}
