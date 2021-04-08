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
private class RxJsPipeMapStep extends TaintTracking::SharedTaintStep {
  override predicate heapStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::MethodCallNode call | call.getMethodName() = "pipe" |
      pred = call.getReceiver() and
      succ = pipeInput(call.getArgument(0).getALocalSource())
      or
      exists(int i |
        pred = pipeOutput(call.getArgument(i).getALocalSource()) and
        succ = pipeInput(call.getArgument(i + 1).getALocalSource())
      )
      or
      pred = pipeOutput(call.getLastArgument().getALocalSource()) and
      succ = call
      or
      // Handle a common case where the last step is `catchError`.
      isIdentityPipe(call.getLastArgument().getALocalSource()) and
      pred = pipeOutput(call.getArgument(call.getNumArgument() - 2)) and
      succ = call
    )
  }
}
