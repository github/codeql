/**
 * Provides data flow steps for promisified user-defined function calls.
 * This ensures that when you call a promisified user-defined function,
 * arguments flow to the original function's parameters.
 */

private import javascript
private import semmle.javascript.dataflow.AdditionalFlowSteps

/**
 * A data flow step from arguments of promisified user-defined function calls to
 * the parameters of the original function.
 */
class PromisifiedUserFunctionArgumentFlow extends AdditionalFlowStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(
      DataFlow::CallNode promisifiedCall, Promisify::PromisifyCall promisify,
      DataFlow::FunctionNode originalFunc, int i
    |
      // The promisified call flows from a promisify result
      promisify.flowsTo(promisifiedCall.getCalleeNode()) and
      // The original function was promisified
      originalFunc.flowsTo(promisify.getArgument(0)) and
      // Argument i of the promisified call flows to parameter i of the original function
      pred = promisifiedCall.getArgument(i) and
      succ = originalFunc.getParameter(i)
    )
  }
}
