/**
 * @name Server crash
 * @description A server that can be forced to crash may be vulnerable to denial-of-service
 *              attacks.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id js/server-crash
 * @tags security
 *       external/cwe/cwe-248
 *       external/cwe/cwe-730
 */

import javascript

/**
 * Gets a function that indirectly invokes an asynchronous callback through `async`, where the callback throws an uncaught exception at `thrower`.
 */
Function invokesCallbackThatThrowsUncaughtException(
  AsyncSentinelCall async, LikelyExceptionThrower thrower
) {
  async.getAsyncCallee() = throwsUncaughtExceptionInAsyncContext(thrower) and
  result = async.getEnclosingFunction()
  or
  exists(DataFlow::InvokeNode invk, Function fun |
    fun = invokesCallbackThatThrowsUncaughtException(async, thrower) and
    // purposely not checking for `getEnclosingTryCatchStmt`. An async callback called from inside a try-catch can still crash the server.
    result = invk.getEnclosingFunction()
  |
    invk.getACallee() = fun
    or
    // traverse a slightly extended call graph to get additional TPs
    invk.(AsyncSentinelCall).getAsyncCallee() = fun
  )
}

/**
 * Gets a callee of an invocation `invk` that is not guarded by a try statement.
 */
Function getUncaughtExceptionRethrowerCallee(DataFlow::InvokeNode invk) {
  not exists(invk.asExpr().getEnclosingStmt().getEnclosingTryCatchStmt()) and
  result = invk.getACallee()
}

/**
 * Holds if `thrower` is not guarded by a try statement.
 */
predicate isUncaughtExceptionThrower(LikelyExceptionThrower thrower) {
  not exists([thrower.(Expr).getEnclosingStmt(), thrower.(Stmt)].getEnclosingTryCatchStmt())
}

/**
 * Gets a function that may throw an uncaught exception originating at `thrower`, which then may escape in an asynchronous calling context.
 */
Function throwsUncaughtExceptionInAsyncContext(LikelyExceptionThrower thrower) {
  (
    isUncaughtExceptionThrower(thrower) and
    result = thrower.getContainer()
    or
    exists(DataFlow::InvokeNode invk |
      getUncaughtExceptionRethrowerCallee(invk) = throwsUncaughtExceptionInAsyncContext(thrower) and
      result = invk.getEnclosingFunction()
    )
  ) and
  // Anti-case:
  // An exception from an `async` function results in a rejected promise.
  // Unhandled promises requires `node --unhandled-rejections=strict ...` to terminate the process
  // without that flag, the DEP0018 deprecation warning is printed instead (node.js version 14 and below)
  not result.isAsync() and
  // pruning optimization since this predicate always is related to `invokesCallbackThatThrowsUncaughtException`
  result = reachableFromAsyncCallback()
}

/**
 * Holds if `result` is reachable from a callback that is invoked asynchronously.
 */
Function reachableFromAsyncCallback() {
  result instanceof AsyncCallback
  or
  exists(DataFlow::InvokeNode invk |
    invk.getEnclosingFunction() = reachableFromAsyncCallback() and
    result = invk.getACallee()
  )
}

/**
 * The main predicate of this query: used for both result display and path computation.
 */
predicate main(
  HTTP::RouteHandler rh, AsyncSentinelCall async, AsyncCallback cb, LikelyExceptionThrower thrower
) {
  async.getAsyncCallee() = cb and
  rh.getAstNode() = invokesCallbackThatThrowsUncaughtException(async, thrower)
}

/**
 * A call that may cause a function to be invoked in an asynchronous context outside of the visible source code.
 */
class AsyncSentinelCall extends DataFlow::CallNode {
  Function asyncCallee;

  AsyncSentinelCall() {
    exists(DataFlow::FunctionNode node | node.getAstNode() = asyncCallee |
      // manual models
      exists(string memberName |
        not memberName.matches("%Sync") and
        this = NodeJSLib::FS::moduleMember(memberName).getACall() and
        node = this.getCallback([1 .. 2])
      )
      // (add additional cases here to improve the query)
    )
  }

  /**
   * Gets the callee that is invoked in an asynchronous context.
   */
  Function getAsyncCallee() { result = asyncCallee }
}

/**
 * A callback provided to an asynchronous call (heuristic).
 */
class AsyncCallback extends Function {
  AsyncCallback() { any(AsyncSentinelCall c).getAsyncCallee() = this }
}

/**
 * A node that is likely to throw an exception.
 *
 * This is the primary extension point for this query.
 */
abstract class LikelyExceptionThrower extends AstNode { }

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

/**
 * Edges that builds an explanatory graph that follows the mental model of how the the exception flows.
 *
 * - step 1. exception is thrown
 * - step 2. exception escapes the enclosing function
 * - step 3. exception follows the call graph backwards until an async callee is encountered
 * - step 4. (at this point, the program crashes)
 */
query predicate edges(AstNode pred, AstNode succ) {
  exists(LikelyExceptionThrower thrower | main(_, _, _, thrower) |
    pred = thrower and
    succ = thrower.getContainer()
    or
    exists(DataFlow::InvokeNode invk, Function fun |
      fun = throwsUncaughtExceptionInAsyncContext(thrower)
    |
      succ = invk.getAstNode() and
      pred = invk.getACallee() and
      pred = fun
      or
      succ = fun and
      succ = invk.getContainer() and
      pred = invk.getAstNode()
    )
  )
}

/**
 * Holds if `node` is in the `edge/2` relation above.
 */
query predicate nodes(AstNode node) {
  edges(node, _) or
  edges(_, node)
}

from
  HTTP::RouteHandler rh, AsyncSentinelCall async, DataFlow::Node callbackArg, AsyncCallback cb,
  ExprOrStmt crasher
where
  main(rh, async, cb, crasher) and
  callbackArg.getALocalSource().getAstNode() = cb and
  async.getAnArgument() = callbackArg
select crasher, crasher, cb,
  "The server of $@ will terminate when an uncaught exception from here escapes this $@", rh,
  "this route handler", callbackArg, "asynchronous callback"
