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
 * Gets a function that is invoked by `asyncCallback` without any try-block wrapping, `asyncCallback` is in turn is called indirectly by `routeHandler`.
 * 
 * If the result throws an excection, the server of `routeHandler` will crash.
 */
Function getAPotentialServerCrasher(
  HTTP::RouteHandler routeHandler, DataFlow::FunctionNode asyncCallback
) {
  exists(AsyncCall asyncCall |
    // the route handler transitively calls an async function
    asyncCall.getEnclosingFunction() =
      getACallee*(routeHandler.(DataFlow::FunctionNode).getFunction()) and
    asyncCallback = asyncCall.getCallback() and
    // the async function transitively calls a function that may throw an exception out of the the async function
    result = getAnUnguardedCallee*(asyncCallback.getFunction())
  )
}

/**
 * Gets an AST node that is likely to throw an uncaught exception in `fun`.
 */
ExprOrStmt getALikelyExceptionThrower(Function fun) {
  result.getContainer() = fun and
  not exists([result.(Expr).getEnclosingStmt(), result.(Stmt)].getEnclosingTryCatchStmt()) and
  (isLikelyToThrow(result.(Expr).flow()) or result instanceof ThrowStmt)
}

from HTTP::RouteHandler routeHandler, DataFlow::FunctionNode asyncCallback, ExprOrStmt crasher
where crasher = getALikelyExceptionThrower(getAPotentialServerCrasher(routeHandler, asyncCallback))
select crasher, "When an exception is thrown here and later exits $@, the server of $@ will crash.",
  asyncCallback, "this asynchronous callback", routeHandler, "this route handler"
