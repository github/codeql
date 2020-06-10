/**
 * @name Server crash
 * @description A server that can be forced to crash may be vulnerable to denial-of-service
 *              attacks.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/server-crash
 * @tags security
 *       external/cwe/cwe-730
 */

import javascript

/**
 * Gets a function that `caller` invokes.
 */
Function getACallee(Function caller) {
  exists(DataFlow::InvokeNode invk |
    invk.getEnclosingFunction() = caller and result = invk.getACallee()
  )
}

/**
 * Gets a function that `caller` invokes, excluding calls guarded in `try`-blocks.
 */
Function getAnUnguardedCallee(Function caller) {
  exists(DataFlow::InvokeNode invk |
    invk.getEnclosingFunction() = caller and
    result = invk.getACallee() and
    not exists(invk.asExpr().getEnclosingStmt().getEnclosingTryCatchStmt())
  )
}

predicate isHeaderValue(HTTP::ExplicitHeaderDefinition def, DataFlow::Node node) {
  def.definesExplicitly(_, node.asExpr())
}

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "Configuration" }

  override predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node node) {
    // using control characters in a header value will cause an exception
    isHeaderValue(_, node)
  }
}

predicate isLikelyToThrow(DataFlow::Node crash) {
  exists(Configuration cfg, DataFlow::Node sink | cfg.hasFlow(_, sink) | isHeaderValue(crash, sink))
}

/**
 * A call that looks like it is asynchronous.
 */
class AsyncCall extends DataFlow::CallNode {
  DataFlow::FunctionNode callback;

  AsyncCall() {
    callback.flowsTo(getLastArgument()) and
    callback.getParameter(0).getName() = ["e", "err", "error"] and
    callback.getNumParameter() = 2 and
    not exists(callback.getAReturn())
  }

  DataFlow::FunctionNode getCallback() { result = callback }
}

/**
 * A node that will crash a server if it throws an exception.
 *
 * The crash happens because a route handler invokes an asynchronous function that in turn throws an exception produced by this node.
 */
class ServerCrasher extends ExprOrStmt {
  HTTP::RouteHandler routeHandler;
  DataFlow::FunctionNode asyncFunction;

  ServerCrasher() {
    exists(AsyncCall asyncCall, Function throwingFunction |
      // the route handler transitively calls an async function
      asyncCall.getEnclosingFunction() =
        getACallee*(routeHandler.(DataFlow::FunctionNode).getFunction()) and
      asyncFunction = asyncCall.getCallback() and
      // the async function transitively calls a function that may throw an exception out of the the async function
      throwingFunction = getAnUnguardedCallee*(asyncFunction.getFunction()) and
      this.getContainer() = throwingFunction and
      not exists([this.(Expr).getEnclosingStmt(), this.(Stmt)].getEnclosingTryCatchStmt())
    )
  }

  /**
   * Gets the asynchronous function from which a server-crashing exception escapes.
   */
  DataFlow::FunctionNode getAsyncFunction() { result = asyncFunction }

  /**
   * Gets the route handler that ultimately is responsible for the server crash.
   */
  HTTP::RouteHandler getRouteHandler() { result = routeHandler }
}

from ServerCrasher crasher
where isLikelyToThrow(crasher.(Expr).flow()) or crasher instanceof ThrowStmt
select crasher, "When an exception is thrown here and later exits $@, the server of $@ will crash.",
  crasher.getAsyncFunction(), "an asynchronous function", crasher.getRouteHandler(),
  "this route handler"
