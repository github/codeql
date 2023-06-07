/**
 * Provides modeling for Rack applications.
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.typetracking.TypeTracker
private import Response::Private as RP

private DataFlow::LocalSourceNode trackRackResponse(TypeTracker t, RP::PotentialResponseNode n) {
  t.start() and
  result = n
  or
  exists(TypeTracker t2 | result = trackRackResponse(t2, n).track(t2, t))
}

private DataFlow::Node trackRackResponse(RP::PotentialResponseNode n) {
  trackRackResponse(TypeTracker::end(), n).flowsTo(result)
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
    private DataFlow::MethodNode call;
    private RP::PotentialResponseNode resp;

    AppCandidate() {
      call = this.getInstanceMethod("call") and
      call.getNumberOfParameters() = 1 and
      call.getAReturningNode() = trackRackResponse(resp)
    }

    /**
     * Gets the environment of the request, which is the lone parameter to the `call` method.
     */
    DataFlow::ParameterNode getEnv() { result = call.getParameter(0) }

    /** Gets the response returned from the request. */
    RP::PotentialResponseNode getResponse() { result = resp }
  }
}
