/** Provides predicates for tracking functions through wrapper functions. */

private import javascript
private import FlowSteps as FlowSteps
private import semmle.javascript.internal.CachedStages

cached
private module Cached {
  private predicate forwardsParameter(
    DataFlow::FunctionNode function, int i, DataFlow::CallNode call
  ) {
    exists(DataFlow::ParameterNode parameter | parameter = function.getParameter(i) |
      not parameter.isRestParameter() and
      parameter.flowsTo(call.getArgument(i))
      or
      parameter.isRestParameter() and
      parameter.flowsTo(call.getASpreadArgument())
    )
  }

  cached
  private module Stage {
    // Forces the module to be computed as part of the type-tracking stage.
    cached
    predicate forceStage() { Stages::TypeTracking::ref() }
  }

  /**
   * Holds if the function in `succ` forwards all its arguments to a call to `pred` and returns
   * its result. This can thus be seen as a step `pred -> succ` used for tracking function values
   * through "wrapper functions", since the `succ` function partially replicates behavior of `pred`.
   *
   * Examples:
   * ```js
   * function f(x) {
   *   return g(x); // step: g -> f
   * }
   *
   * function doExec(x) {
   *   console.log(x);
   *   return exec(x); // step: exec -> doExec
   * }
   *
   * function doEither(x, y) {
   *   if (x > y) {
   *     return foo(x, y); // step: foo -> doEither
   *   } else {
   *     return bar(x, y); // step: bar -> doEither
   *   }
   * }
   *
   * function wrapWithLogging(f) {
   *   return (x) => {
   *     console.log(x);
   *     return f(x); // step: f -> anonymous function
   *   }
   * }
   * wrapWithLogging(g); // step: g -> wrapWithLogging(g)
   * ```
   */
  cached
  predicate functionForwardingStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::FunctionNode function, DataFlow::CallNode call |
      call.flowsTo(function.getReturnNode()) and
      forall(int i | exists([call.getArgument(i), function.getParameter(i)]) |
        forwardsParameter(function, i, call)
      ) and
      pred = call.getCalleeNode() and
      succ = function
    )
    or
    // Given a generic wrapper function like,
    //
    //   function wrap(f) { return (x, y) => f(x, y) };
    //
    // add steps through calls to that function: `g -> wrap(g)`
    exists(
      DataFlow::FunctionNode wrapperFunction, DataFlow::SourceNode param, DataFlow::Node paramUse
    |
      FlowSteps::argumentPassing(succ, pred, wrapperFunction.getFunction(), param) and
      param.flowsTo(paramUse) and
      functionForwardingStep(paramUse, wrapperFunction.getReturnNode().getALocalSource())
    )
  }

  /**
   * Holds if the function in `succ` forwards all its arguments to a call to `pred`.
   * This can thus be seen as a step `pred -> succ` used for tracking function values
   * through "wrapper functions", since the `succ` function partially replicates behavior of `pred`.
   *
   * This is similar to `functionForwardingStep` except the innermost forwarding call does not
   * need flow to the return value; this can be useful for tracking callback-style functions
   * where the result tends to be unused.
   *
   * Examples:
   * ```js
   * function f(x, callback) {
   *   g(x, callback); // step: g -> f
   * }
   *
   * function doExec(x, callback) {
   *   console.log(x);
   *   exec(x, callback); // step: exec -> doExec
   * }
   *
   * function doEither(x, y) {
   *   if (x > y) {
   *     return foo(x, y); // step: foo -> doEither
   *   } else {
   *     return bar(x, y); // step: bar -> doEither
   *   }
   * }
   *
   * function wrapWithLogging(f) {
   *   return (x) => {
   *     console.log(x);
   *     return f(x); // step: f -> anonymous function
   *   }
   * }
   * wrapWithLogging(g); // step: g -> wrapWithLogging(g)
   * ```
   */
  cached
  predicate functionOneWayForwardingStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::FunctionNode function, DataFlow::CallNode call |
      call.getContainer() = function.getFunction() and
      forall(int i | exists(function.getParameter(i)) | forwardsParameter(function, i, call)) and
      pred = call.getCalleeNode() and
      succ = function
    )
    or
    // Given a generic wrapper function like,
    //
    //   function wrap(f) { return (x, y) => f(x, y) };
    //
    // add steps through calls to that function: `g -> wrap(g)`
    exists(
      DataFlow::FunctionNode wrapperFunction, DataFlow::SourceNode param, DataFlow::Node paramUse
    |
      FlowSteps::argumentPassing(succ, pred, wrapperFunction.getFunction(), param) and
      param.flowsTo(paramUse) and
      functionOneWayForwardingStep(paramUse, wrapperFunction.getReturnNode().getALocalSource())
    )
  }
}

import Cached
