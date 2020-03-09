import javascript
private import semmle.javascript.dataflow.InferredTypes

/**
 * Classes and predicates for modelling TaintTracking steps for arrays.
 */ 
module ArrayTaintTracking {
  /**
   * A taint propagating data flow edge caused by the builtin array functions.
   */
  private class ArrayFunctionTaintStep extends TaintTracking::AdditionalTaintStep {
    DataFlow::CallNode call;

    ArrayFunctionTaintStep() { this = call }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      arrayFunctionTaintStep(pred, succ, call)
    }
  }

  /**
   * A taint propagating data flow edge from `pred` to `succ` caused by a call `call` to a builtin array functions.
   */
  predicate arrayFunctionTaintStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::CallNode call) {
    // `array.map(function (elt, i, ary) { ... })`: if `array` is tainted, then so are
    // `elt` and `ary`; similar for `forEach`
    exists(string name, Function f, int i |
      (name = "map" or name = "forEach") and
      (i = 0 or i = 2) and
      call.getArgument(0).analyze().getAValue().(AbstractFunction).getFunction() = f and
      call.(DataFlow::MethodCallNode).getMethodName() = name and
      pred = call.getReceiver() and
      succ = DataFlow::parameterNode(f.getParameter(i))
    )
    or
    // `array.map` with tainted return value in callback
    exists(DataFlow::FunctionNode f |
      call.(DataFlow::MethodCallNode).getMethodName() = "map" and
      call.getArgument(0) = f and // Require the argument to be a closure to avoid spurious call/return flow
      pred = f.getAReturn() and
      succ = call
    )
    or
    // `array.push(e)`, `array.unshift(e)`: if `e` is tainted, then so is `array`.
    exists(string name |
      name = "push" or
      name = "unshift"
    |
      pred = call.getAnArgument() and
      succ.(DataFlow::SourceNode).getAMethodCall(name) = call
    )
    or
    // `array.push(...e)`, `array.unshift(...e)`: if `e` is tainted, then so is `array`.
    exists(string name |
      name = "push" or
      name = "unshift"
    |
      pred = call.getASpreadArgument() and
      // Make sure we handle reflective calls
      succ = call.getReceiver().getALocalSource() and
      call.getCalleeName() = name
    )
    or
    // `array.splice(i, del, e)`: if `e` is tainted, then so is `array`.
    exists(string name | name = "splice" |
      pred = call.getArgument(2) and
      succ.(DataFlow::SourceNode).getAMethodCall(name) = call
    )
    or
    // `e = array.pop()`, `e = array.shift()`, or similar: if `array` is tainted, then so is `e`.
    exists(string name |
      name = "pop" or
      name = "shift" or
      name = "slice" or
      name = "splice"
    |
      call.(DataFlow::MethodCallNode).calls(pred, name) and
      succ = call
    )
    or
    // `e = Array.from(x)`: if `x` is tainted, then so is `e`.
    call = DataFlow::globalVarRef("Array").getAPropertyRead("from").getACall() and
    pred = call.getAnArgument() and
    succ = call
    or
    // `e = arr1.concat(arr2, arr3)`: if any of the `arr` is tainted, then so is `e`.
    call.(DataFlow::MethodCallNode).calls(pred, "concat") and
    succ = call
    or
    call.(DataFlow::MethodCallNode).getMethodName() = "concat" and
    succ = call and
    pred = call.getAnArgument()
  }
}
