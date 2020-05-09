/**
 * Provides classes for reasoning about composed functions.
 */

import javascript

/**
 * A function composed from a collection of functions.
 */
private class ComposedFunction extends DataFlow::CallNode {
  ComposedFunction() {
    exists(string name |
      name = "just-compose" or
      name = "compose-function"
    |
      this = DataFlow::moduleImport(name).getACall()
    )
    or
    this = LodashUnderscore::member("flow").getACall()
  }

  /**
   * Gets the ith function in this composition.
   */
  DataFlow::FunctionNode getFunction(int i) { result.flowsTo(getArgument(i)) }
}

/**
 * A taint step for a composed function.
 */
private class ComposedFunctionTaintStep extends TaintTracking::SharedTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(
      int fnIndex, DataFlow::FunctionNode fn, ComposedFunction composed, DataFlow::CallNode call
    |
      fn = composed.getFunction(fnIndex) and
      call = composed.getACall()
    |
      // flow out of the composed call
      fnIndex = composed.getNumArgument() - 1 and
      pred = fn.getAReturn() and
      succ = call
      or
      if fnIndex = 0
      then
        // flow into the first composed function
        exists(int callArgIndex |
          pred = call.getArgument(callArgIndex) and
          succ = fn.getParameter(callArgIndex)
        )
      else
        // flow through the composed functions
        exists(DataFlow::FunctionNode predFn | predFn = composed.getFunction(fnIndex - 1) |
          pred = predFn.getAReturn() and
          succ = fn.getParameter(0)
        )
    )
  }
}
