/**
 * Provides taint steps modeling flow through `rxjs` Observable objects.
 */

private import javascript

/**
 * A step `x -> y` in `x.subscribe(y => ...)`, modeling flow out of an rxjs Observable.
 */
private class RxJsSubscribeStep extends TaintTracking::SharedTaintStep {
  override predicate heapStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::MethodCallNode call | call.getMethodName() = "subscribe" |
      pred = call.getReceiver() and
      succ = call.getCallback(0).getParameter(0)
    )
  }
}

/**
 * Gets a data flow node that can take the value of any input sent to `pipe`.
 *
 * For example, in `map(x => ...)`, `x` refers to any value sent to the pipe
 * created by the `map` call.
 */
private DataFlow::Node pipeInput(DataFlow::CallNode pipe) {
  pipe = DataFlow::moduleMember("rxjs/operators", any(string s | not s = "catchError")).getACall() and
  result = pipe.getCallback(0).getParameter(0)
}

/**
 * Gets a data flow node whose value becomes the output of the given `pipe`.
 *
 * For example, in `map(x => x + 1)`, the `x + 1` node becomes the output of
 * the pipe.
 */
private DataFlow::Node pipeOutput(DataFlow::CallNode pipe) {
  // we assume if there is a return, it is an output.
  pipe = DataFlow::moduleMember("rxjs/operators", _).getACall() and
  result = pipe.getCallback(0).getReturnNode()
  or
  pipe = DataFlow::moduleMember("rxjs/operators", "filter").getACall() and
  result = pipe.getCallback(0).getParameter(0)
}

/**
 * Holds if `pipe` acts as the identity function for success values.
 *
 * We currently lack a data-flow node to represent its input/ouput so it must
 * be special-cased.
 */
private predicate isIdentityPipe(DataFlow::CallNode pipe) {
  pipe = DataFlow::moduleMember("rxjs/operators", ["catchError", "tap"]).getACall()
}

/**
 * A call to `pipe`, which is assumed to be an `rxjs/operators` pipe.
 *
 * Has utility methods `getInput`/`getOutput` to get the input/output of each
 * element of the pipe.
 * These utility methods automatically handle itentity pipes, and the
 * first/last elements of the pipe.
 */
private class RxJSPipe extends DataFlow::MethodCallNode {
  RxJSPipe() { this.getMethodName() = "pipe" }

  /**
   * Gets an input to pipe element `i`.
   * Or if `i` is equal to the number of elements, gets the output of the pipe (the call itself)
   */
  DataFlow::Node getInput(int i) {
    result = pipeInput(this.getArgument(i).getALocalSource())
    or
    i = this.getNumArgument() and
    result = this
  }

  /**
   * Gets an output from pipe element `i`.
   * Handles identity pipes by getting the output from the previous element.
   * If `i` is -1, gets the receiver to the call, which started the pipe.
   */
  DataFlow::Node getOutput(int i) {
    isIdentityPipe(this.getArgument(i).getALocalSource()) and
    result = this.getOutput(i - 1)
    or
    not isIdentityPipe(this.getArgument(i).getALocalSource()) and
    result = pipeOutput(this.getArgument(i).getALocalSource())
    or
    i = -1 and
    result = this.getReceiver()
  }
}

/**
 * A step in or out of the map callback in a call of form `x.pipe(map(y => ...))`.
 */
private class RxJsPipeMapStep extends TaintTracking::SharedTaintStep {
  override predicate heapStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(RxJSPipe pipe, int i |
      pred = pipe.getOutput(i) and
      succ = pipe.getInput(i + 1)
    )
  }
}
