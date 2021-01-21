/**
 * Provides taint steps modeling flow through `rxjs` Observable objects.
 */

private import javascript

/**
 * A step `x -> y` in `x.subscribe(y => ...)`, modeling flow out of an rxjs Observable.
 */
private class RxJsSubscribeStep extends TaintTracking::AdditionalTaintStep, DataFlow::MethodCallNode {
  RxJsSubscribeStep() { getMethodName() = "subscribe" }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred = getReceiver() and
    succ = getCallback(0).getParameter(0)
  }
}

/**
 * Gets a data flow node that can take the value of any input sent to `pipe`.
 *
 * For example, in `map(x => ...)`, `x` refers to any value sent to the pipe
 * created by the `map` call.
 */
private DataFlow::Node pipeInput(DataFlow::CallNode pipe) {
  pipe = DataFlow::moduleMember("rxjs/operators", ["map", "filter"]).getACall() and
  result = pipe.getCallback(0).getParameter(0)
}

/**
 * Gets a data flow node whose value becomes the output of the given `pipe`.
 *
 * For example, in `map(x => x + 1)`, the `x + 1` node becomes the output of
 * the pipe.
 */
private DataFlow::Node pipeOutput(DataFlow::CallNode pipe) {
  pipe = DataFlow::moduleMember("rxjs/operators", "map").getACall() and
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
  pipe = DataFlow::moduleMember("rxjs/operators", "catchError").getACall()
}

/**
 * A step in or out of the map callback in a call of form `x.pipe(map(y => ...))`.
 */
private class RxJsPipeMapStep extends TaintTracking::AdditionalTaintStep, DataFlow::MethodCallNode {
  RxJsPipeMapStep() { getMethodName() = "pipe" }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred = getReceiver() and
    succ = pipeInput(getArgument(0).getALocalSource())
    or
    exists(int i |
      pred = pipeOutput(getArgument(i).getALocalSource()) and
      succ = pipeInput(getArgument(i + 1).getALocalSource())
    )
    or
    pred = pipeOutput(getLastArgument().getALocalSource()) and
    succ = this
    or
    // Handle a common case where the last step is `catchError`.
    isIdentityPipe(getLastArgument().getALocalSource()) and
    pred = pipeOutput(getArgument(getNumArgument() - 2)) and
    succ = this
  }
}
