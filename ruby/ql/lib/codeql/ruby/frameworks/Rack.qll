/**
 * Provides modeling for the Rack library.
 */

private import codeql.ruby.Concepts
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
    private PotentialResponseNode resp;

    AppCandidate() {
      call = this.getInstanceMethod("call") and
      call.getNumberOfParameters() = 1 and
      call.getReturn() = trackRackResponse(resp)
    }

    /**
     * Gets the environment of the request, which is the lone parameter to the `call` method.
     */
    DataFlow::ParameterNode getEnv() { result = call.getParameter(0) }

    /** Gets the response returned from the request. */
    PotentialResponseNode getResponse() { result = resp }
  }

  private DataFlow::LocalSourceNode trackInt(TypeTracker t, int i) {
    t.start() and
    result.getConstantValue().isInt(i)
    or
    exists(TypeTracker t2 | result = trackInt(t2, i).track(t2, t))
  }

  private DataFlow::Node trackInt(int i) { trackInt(TypeTracker::end(), i).flowsTo(result) }

  private class PotentialResponseNode extends DataFlow::ArrayLiteralNode {
    // [status, headers, body]
    PotentialResponseNode() { this.getNumberOfArguments() = 3 }

    /**
     * Gets an HTTP status code that may be returned in this response.
     */
    int getAStatusCode() { this.getElement(0) = trackInt(result) }
  }

  private DataFlow::LocalSourceNode trackRackResponse(TypeTracker t, PotentialResponseNode n) {
    t.start() and
    result = n
    or
    exists(TypeTracker t2 | result = trackRackResponse(t2, n).track(t2, t))
  }

  private DataFlow::Node trackRackResponse(PotentialResponseNode n) {
    trackRackResponse(TypeTracker::end(), n).flowsTo(result)
  }

  /** A `DataFlow::Node` returned from a rack request. */
  class ResponseNode extends PotentialResponseNode, Http::Server::HttpResponse::Range {
    ResponseNode() { this = any(AppCandidate app).getResponse() }

    override DataFlow::Node getBody() { result = this.getElement(2) }

    // TODO
    override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

    // TODO
    override string getMimetypeDefault() { none() }
  }
}
