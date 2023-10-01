/**
 * Provides modeling for Rack applications.
 */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.typetracking.TypeTracker
private import Response::Private as RP

/**
 * A callable node that takes a single argument and, if it has a method name,
 * is called "call".
 */
private class PotentialRequestHandler extends DataFlow::CallableNode {
  PotentialRequestHandler() {
    this.getNumberOfParameters() = 1 and
    (
      this.(DataFlow::MethodNode).getMethodName() = "call"
      or
      this = API::getTopLevelCall("run").getArgument(0).asCallable()
    )
  }
}

private DataFlow::LocalSourceNode trackRackResponse(TypeBackTracker t, PotentialRequestHandler call) {
  t.start() and
  result = call.getAReturnNode().getALocalSource()
  or
  exists(TypeBackTracker t2 | result = trackRackResponse(t2, call).backtrack(t2, t))
}

private RP::PotentialResponseNode trackRackResponse(PotentialRequestHandler call) {
  result = trackRackResponse(TypeBackTracker::end(), call)
}

/**
 * Provides modeling for Rack applications.
 */
module App {
  /**
   * DEPRECATED: Use `RequestHandler` instead.
   * A class that may be a rack application.
   * This is a class that has a `call` method that takes a single argument
   * (traditionally called `env`) and returns a rack-compatible response.
   */
  deprecated class AppCandidate extends DataFlow::ClassNode {
    private RequestHandler call;
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

  /**
   * A callable node that looks like it implements the rack specification.
   */
  class RequestHandler extends PotentialRequestHandler {
    private RP::PotentialResponseNode resp;

    RequestHandler() { resp = trackRackResponse(this) }

    /** Gets the `env` parameter passed to this request handler. */
    DataFlow::ParameterNode getEnv() { result = this.getParameter(0) }

    /** Gets a response returned from this request handler. */
    RP::PotentialResponseNode getAResponse() { result = resp }
  }

  /** A read of the query string via `env['QUERY_STRING']`. */
  private class EnvQueryStringRead extends Http::Server::RequestInputAccess::Range {
    EnvQueryStringRead() {
      this =
        any(RequestHandler h)
            .getEnv()
            .getAnElementRead(ConstantValue::fromStringlikeValue("QUERY_STRING"))
    }

    override string getSourceType() { result = "Rack env" }

    override Http::Server::RequestInputKind getKind() {
      result = Http::Server::parameterInputKind()
    }
  }
}
