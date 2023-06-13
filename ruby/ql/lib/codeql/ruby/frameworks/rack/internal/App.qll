/**
 * Provides modeling for Rack applications.
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.typetracking.TypeTracker
private import Response::Private as RP

/**
 * A callable node that takes a single argument and, if it has a method name,
 * is called "call".
 */
private class PotentialCallNode extends DataFlow::CallableNode {
  PotentialCallNode() {
    this.getNumberOfParameters() = 1 and
    (
      this.(DataFlow::MethodNode).getMethodName() = "call" or
      not this instanceof DataFlow::MethodNode
    )
  }
}

/**
 * A callable node that looks like it implements the rack specification.
 */
private class CallNode extends PotentialCallNode {
  private RP::PotentialResponseNode resp;

  CallNode() { resp = trackRackResponse(this) }

  /** Gets the response returned from a request to this application. */
  RP::PotentialResponseNode getResponse() { result = resp }
}

private DataFlow::LocalSourceNode trackRackResponse(TypeBackTracker t, DataFlow::CallableNode call) {
  t.start() and
  result = call.getAReturnNode().getALocalSource()
  or
  exists(TypeBackTracker t2 | result = trackRackResponse(t2, call).backtrack(t2, t))
}

private RP::PotentialResponseNode trackRackResponse(DataFlow::CallableNode call) {
  result = trackRackResponse(TypeBackTracker::end(), call)
}

/**
 * Provides modeling for Rack applications.
 */
module App {
  /**
   * DEPRECATED: Use `App` instead.
   * A class that may be a rack application.
   * This is a class that has a `call` method that takes a single argument
   * (traditionally called `env`) and returns a rack-compatible response.
   */
  deprecated class AppCandidate extends DataFlow::ClassNode {
    private CallNode call;
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

  private newtype TApp =
    TClassApp(DataFlow::ClassNode cn, CallNode call) or
    TAnonymousApp(CallNode call)

  /**
   * A rack application. This is either some object that responds to `call`
   * taking a single argument and returns a rack response, or a lambda or
   * proc that takes a single `env` argument and returns a rack response.
   */
  abstract class App extends TApp {
    string toString() { result = "Rack application" }

    abstract CallNode getCall();

    RP::PotentialResponseNode getResponse() { result = this.getCall().getResponse() }

    DataFlow::ParameterNode getEnv() { result = this.getCall().getParameter(0) }
  }

  /**
   * A rack application using a `DataFlow::ClassNode`. The class has either
   * an instance method or a singleton method named "call" which takes a
   * single `env` argument and returns a rack response.
   */
  private class ClassApp extends TApp, App {
    private DataFlow::ClassNode cn;
    private CallNode call;

    ClassApp() {
      this = TClassApp(cn, call) and
      call = [cn.getInstanceMethod("call"), cn.getSingletonMethod("call")]
    }

    override string toString() { result = "Rack application: " + cn.toString() }

    override CallNode getCall() { result = call }
  }

  /**
   * A rack application that is either a lambda or a proc, which takes a
   * single `env` argument and returns a rack response.
   */
  private class AnonymousApp extends TApp, App {
    private CallNode call;

    AnonymousApp() {
      this = TAnonymousApp(call) and
      not exists(DataFlow::ClassNode cn |
        call = [cn.getInstanceMethod(_), cn.getSingletonMethod(_)]
      )
    }

    override string toString() { result = "Rack application: " + call.toString() }

    override CallNode getCall() { result = call }
  }
}
