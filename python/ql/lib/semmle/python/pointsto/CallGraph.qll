/**
 * Context-sensitive call-graph.
 *
 * NOTE: Since an "invocation" contains callsite information
 * and a path back to its ancestor calls, the "invocation" call-graph must be a tree.
 * This has two important consequences:
 *    1.  The graph is incomplete; it has quite limited depth in order to keep the graph to a sensible size.
 *    2.  The graph is precise. Since different invocations are distinct, there can be no "cross-talk" between
 *        different calls to the same function.
 */

import python
private import semmle.python.pointsto.PointsToContext

private newtype TTInvocation =
  TInvocation(FunctionObject f, Context c) {
    exists(Context outer, CallNode call |
      call = f.getACall(outer) and
      c.fromCall(call, outer)
    )
    or
    c.appliesToScope(f.getFunction())
  }

/**
 * A function invocation.
 *
 * This class represents a static approximation to the
 * dynamic call-graph. A `FunctionInvocation` represents
 * all calls made to a function for a given context.
 */
class FunctionInvocation extends TTInvocation {
  /** Gets a textual representation of this element. */
  string toString() { result = "Invocation" }

  FunctionObject getFunction() { this = TInvocation(result, _) }

  Context getContext() { this = TInvocation(_, result) }

  /**
   * Gets the callee invocation for the given callsite.
   * The callsite must be within the function of this invocation.
   */
  FunctionInvocation getCallee(CallNode call) {
    exists(
      FunctionObject callee, Context callee_context, FunctionObject caller, Context caller_context
    |
      this = TInvocation(caller, caller_context) and
      result = TInvocation(callee, callee_context) and
      call = callee.getACall(caller_context) and
      callee_context.fromCall(call, caller_context) and
      call.getScope() = caller.getFunction()
    )
  }

  /**
   * Gets a callee invocation.
   * That is any invocation made from within this invocation.
   */
  FunctionInvocation getACallee() { result = this.getCallee(_) }

  /** Holds if this is an invocation `f` in the "runtime" context. */
  predicate runtime(FunctionObject f) {
    exists(Context c |
      c.isRuntime() and
      this = TInvocation(f, c)
    )
  }

  /** Gets the call from which this invocation was made. */
  CallNode getCall() { this.getContext().fromCall(result, _) }

  /** Gets the caller invocation of this invocation, if any. */
  FunctionInvocation getCaller() { this = result.getCallee(_) }
}
