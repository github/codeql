/**
 * @name Server crash
 * @description A server that can be forced to crash may be vulnerable to denial-of-service
 *              attacks.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/server-crash
 * @tags security
 *       external/cwe/cwe-730
 */

import javascript

/**
 * A call that appears to be asynchronous (heuristic).
 */
class AsyncCall extends DataFlow::CallNode {
  DataFlow::FunctionNode callback;

  AsyncCall() {
    callback.flowsTo(getLastArgument()) and
    callback.getParameter(0).getName() = ["e", "err", "error"] and
    callback.getNumParameter() = 2 and
    not exists(callback.getAReturn())
  }

  /**
   * Gets the callback that is invoked asynchronously.
   */
  DataFlow::FunctionNode getCallback() { result = callback }
}

/**
 * Gets a function that is invoked as a consequence of invoking a route handler `rh`.
 */
Function invokedByRouteHandler(HTTP::RouteHandler rh) {
  rh = result.flow()
  or
  // follow the immediate call graph
  exists(DataFlow::InvokeNode invk |
    result = invk.getACallee() and
    invk.getEnclosingFunction() = invokedByRouteHandler(rh)
  )
  // if new edges are added here, the `edges` predicate should be updated accordingly
}

/**
 * A callback provided to an asynchronous call.
 */
class AsyncCallback extends DataFlow::FunctionNode {
  AsyncCallback() { this = any(AsyncCall c).getCallback() }
}

/**
 * Gets a function that is in a call stack that starts at an asynchronous `callback`, calls in the call stack occur outside of `try` blocks.
 */
Function inUnguardedAsyncCallStack(AsyncCallback callback) {
  callback = result.flow()
  or
  exists(DataFlow::InvokeNode invk |
    result = invk.getACallee() and
    not exists(invk.asExpr().getEnclosingStmt().getEnclosingTryCatchStmt()) and
    invk.getEnclosingFunction() = inUnguardedAsyncCallStack(callback)
  )
}

/**
 * Gets a function that is invoked by `asyncCallback` without any try-block wrapping, `asyncCallback` is in turn is called indirectly by `routeHandler`.
 *
 * If the result throws an excection, the server of `routeHandler` will crash.
 */
Function getAPotentialServerCrasher(
  HTTP::RouteHandler routeHandler, AsyncCall asyncCall, AsyncCallback asyncCallback
) {
  // the route handler transitively calls an async function
  asyncCall.getEnclosingFunction() = invokedByRouteHandler(routeHandler) and
  asyncCallback = asyncCall.getCallback() and
  // the async function transitively calls a function that may throw an exception out of the the async function
  result = inUnguardedAsyncCallStack(asyncCallback)
}

/**
 * Gets a node that is likely to throw an uncaught exception in `fun`.
 */
LikelyExceptionThrower getALikelyUncaughtExceptionThrower(Function fun) {
  result.getContainer() = fun and
  not exists([result.(Expr).getEnclosingStmt(), result.(Stmt)].getEnclosingTryCatchStmt())
}

/**
 * Edges that builds an explanatory graph that follows the mental model of how the the exception flows.
 *
 * - step 1. exception is thrown
 * - step 2. exception exits the enclosing function
 * - step 3. exception follows the call graph backwards until an async callee is encountered
 * - step 4. (at this point, the program crashes)
 * - step 5. if the program had not crashed, the exception would conceptually follow the call graph backwards to a route handler
 */
query predicate edges(ASTNode pred, ASTNode succ) {
  nodes(pred) and
  nodes(succ) and
  (
    // the first step from the alert location to the enclosing function
    pred = getALikelyUncaughtExceptionThrower(_) and
    succ = pred.getContainer()
    or
    // ordinary flow graph
    exists(DataFlow::InvokeNode invoke, Function f |
      invoke.getACallee() = f and
      succ = invoke.getAstNode() and
      pred = f
      or
      invoke.getContainer() = f and
      succ = f and
      pred = invoke.getAstNode()
    )
    or
    // the async step
    exists(DataFlow::Node predNode, DataFlow::Node succNode |
      exists(getAPotentialServerCrasher(_, predNode, succNode)) and
      predNode.getAstNode() = succ and
      succNode.getAstNode() = pred
    )
  )
}

/**
 * Nodes for building an explanatory graph that follows the mental model of how the the exception flows.
 */
query predicate nodes(ASTNode node) {
  exists(HTTP::RouteHandler rh, Function fun |
    main(rh, _, _) and
    fun = invokedByRouteHandler(rh)
  |
    node = any(DataFlow::InvokeNode invk | invk.getACallee() = fun).getAstNode() or
    node = fun
  )
  or
  exists(AsyncCallback cb, Function fun |
    main(_, cb, _) and
    fun = inUnguardedAsyncCallStack(cb)
  |
    node = any(DataFlow::InvokeNode invk | invk.getACallee() = fun).getAstNode() or
    node = fun
  )
  or
  main(_, _, node)
}

predicate main(HTTP::RouteHandler rh, AsyncCallback asyncCallback, ExprOrStmt crasher) {
  crasher = getALikelyUncaughtExceptionThrower(getAPotentialServerCrasher(rh, _, asyncCallback))
}

/**
 * A node that is likely to throw an exception.
 *
 * This is the primary extension point for this query.
 */
abstract class LikelyExceptionThrower extends ASTNode { }

/**
 * A `throw` statement.
 */
class TrivialThrowStatement extends LikelyExceptionThrower, ThrowStmt { }

/**
 * Empty class for avoiding emptiness checks from the compiler when there are no Expr-typed instances of the LikelyExceptionThrower type.
 */
class CompilerConfusingExceptionThrower extends LikelyExceptionThrower {
  CompilerConfusingExceptionThrower() { none() }
}

from HTTP::RouteHandler rh, AsyncCallback asyncCallback, ExprOrStmt crasher
where main(rh, asyncCallback, crasher)
select crasher, crasher, rh.getAstNode(),
  "When an exception is thrown here and later escapes at $@, the server of $@ will crash.",
  asyncCallback, "this asynchronous callback", rh, "this route handler"
