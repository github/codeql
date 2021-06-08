import javascript
private import semmle.javascript.dataflow.InferredTypes
private import semmle.javascript.dataflow.internal.PreCallGraphStep

/**
 * Classes and predicates for modelling TaintTracking steps for arrays.
 */
module ArrayTaintTracking {
  /**
   * A taint propagating data flow edge caused by the builtin array functions.
   */
  private class ArrayFunctionTaintStep extends TaintTracking::SharedTaintStep {
    override predicate arrayStep(DataFlow::Node pred, DataFlow::Node succ) {
      arrayFunctionTaintStep(pred, succ, _)
    }
  }

  /**
   * A taint propagating data flow edge from `pred` to `succ` caused by a call `call` to a builtin array functions.
   */
  predicate arrayFunctionTaintStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::CallNode call) {
    // `array.map(function (elt, i, ary) { ... })`: if `array` is tainted, then so are
    // `elt` and `ary`; similar for `forEach`
    exists(Function f |
      call.getArgument(0).getAFunctionValue(0).getFunction() = f and
      call.(DataFlow::MethodCallNode).getMethodName() = ["map", "forEach"] and
      pred = call.getReceiver() and
      succ = DataFlow::parameterNode(f.getParameter([0, 2]))
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
    // `array.filter(x => x)` keeps the taint
    call.(DataFlow::MethodCallNode).getMethodName() = "filter" and
    pred = call.getReceiver() and
    succ = call and
    exists(DataFlow::FunctionNode callback | callback = call.getArgument(0).getAFunctionValue() |
      callback.getParameter(0).getALocalUse() = callback.getAReturn()
    )
    or
    // `array.reduce` with tainted value in callback
    call.(DataFlow::MethodCallNode).getMethodName() = "reduce" and
    pred = call.getArgument(0).(DataFlow::FunctionNode).getAReturn() and // Require the argument to be a closure to avoid spurious call/return flow
    succ = call
    or
    // `array.push(e)`, `array.unshift(e)`: if `e` is tainted, then so is `array`.
    pred = call.getAnArgument() and
    succ.(DataFlow::SourceNode).getAMethodCall(["push", "unshift"]) = call
    or
    // `array.push(...e)`, `array.unshift(...e)`: if `e` is tainted, then so is `array`.
    pred = call.getASpreadArgument() and
    // Make sure we handle reflective calls
    succ = call.getReceiver().getALocalSource() and
    call.getCalleeName() = ["push", "unshift"]
    or
    // `array.splice(i, del, e)`: if `e` is tainted, then so is `array`.
    pred = call.getArgument(2) and
    succ.(DataFlow::SourceNode).getAMethodCall("splice") = call
    or
    // `e = array.pop()`, `e = array.shift()`, or similar: if `array` is tainted, then so is `e`.
    call.(DataFlow::MethodCallNode).calls(pred, ["pop", "shift", "slice", "splice"]) and
    succ = call
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

/**
 * Classes and predicates for modelling data-flow for arrays.
 */
private module ArrayDataFlow {
  private import DataFlow::PseudoProperties

  /**
   * A step modelling the creation of an Array using the `Array.from(x)` method.
   * The step copies the elements of the argument (set, array, or iterator elements) into the resulting array.
   */
  private class ArrayFrom extends DataFlow::SharedFlowStep {
    override predicate loadStoreStep(
      DataFlow::Node pred, DataFlow::Node succ, string fromProp, string toProp
    ) {
      exists(DataFlow::CallNode call |
        call = DataFlow::globalVarRef("Array").getAMemberCall("from") and
        pred = call.getArgument(0) and
        succ = call and
        fromProp = arrayLikeElement() and
        toProp = arrayElement()
      )
    }
  }

  /**
   * A step modelling an array copy where the spread operator is used.
   * The result is essentially array concatenation.
   *
   * Such a step can occur both with the `push` and `unshift` methods, or when creating a new array.
   */
  private class ArrayCopySpread extends DataFlow::SharedFlowStep {
    override predicate loadStoreStep(
      DataFlow::Node pred, DataFlow::Node succ, string fromProp, string toProp
    ) {
      fromProp = arrayLikeElement() and
      toProp = arrayElement() and
      (
        exists(DataFlow::MethodCallNode mcn |
          mcn.getMethodName() = ["push", "unshift"] and
          pred = mcn.getASpreadArgument() and
          succ = mcn.getReceiver().getALocalSource()
        )
        or
        pred = succ.(DataFlow::ArrayCreationNode).getASpreadArgument()
      )
    }
  }

  /**
   * A step for storing an element on an array using `arr.push(e)` or `arr.unshift(e)`.
   */
  private class ArrayAppendStep extends DataFlow::SharedFlowStep {
    override predicate storeStep(DataFlow::Node element, DataFlow::SourceNode obj, string prop) {
      prop = arrayElement() and
      exists(DataFlow::MethodCallNode call |
        call.getMethodName() = ["push", "unshift"] and
        element = call.getAnArgument() and
        obj.getAMethodCall() = call
      )
    }
  }

  /**
   * A node that reads or writes an element from an array inside a for-loop.
   */
  private class ArrayIndexingAccess extends DataFlow::Node {
    DataFlow::PropRef read;

    ArrayIndexingAccess() {
      read = this and
      TTNumber() =
        unique(InferredType type | type = read.getPropertyNameExpr().flow().analyze().getAType()) and
      exists(VarAccess i, ExprOrVarDecl init |
        i = read.getPropertyNameExpr() and init = any(ForStmt f).getInit()
      |
        i.getVariable().getADefinition() = init or
        i.getVariable().getADefinition().(VariableDeclarator).getDeclStmt() = init
      )
    }
  }

  /**
   * A step for reading/writing an element from an array inside a for-loop.
   * E.g. a read from `foo[i]` to `bar` in `for(var i = 0; i < arr.length; i++) {bar = foo[i]}`.
   */
  private class ArrayIndexingStep extends DataFlow::SharedFlowStep {
    override predicate loadStep(DataFlow::Node obj, DataFlow::Node element, string prop) {
      exists(ArrayIndexingAccess access |
        prop = arrayElement() and
        obj = access.(DataFlow::PropRead).getBase() and
        element = access
      )
    }

    override predicate storeStep(DataFlow::Node element, DataFlow::SourceNode obj, string prop) {
      exists(ArrayIndexingAccess access |
        prop = arrayElement() and
        element = access.(DataFlow::PropWrite).getRhs() and
        access = obj.getAPropertyWrite()
      )
    }
  }

  /**
   * A step for retrieving an element from an array using `.pop()` or `.shift()`.
   * E.g. `array.pop()`.
   */
  private class ArrayPopStep extends DataFlow::SharedFlowStep {
    override predicate loadStep(DataFlow::Node obj, DataFlow::Node element, string prop) {
      exists(DataFlow::MethodCallNode call |
        call.getMethodName() = ["pop", "shift"] and
        prop = arrayElement() and
        obj = call.getReceiver() and
        element = call
      )
    }
  }

  /**
   * A step for iterating an array using `map` or `forEach`.
   *
   * Array elements can be loaded from the array `arr` to `e` in e.g: `arr.forEach(e => ...)`.
   *
   * And array elements can be stored into a resulting array using `map(...)`.
   * E.g. in `arr.map(e => foo)`, the resulting array (`arr.map(e => foo)`) will contain the element `foo`.
   *
   * And the second parameter in the callback is the array ifself, so there is a `loadStoreStep` from the array to that second parameter.
   */
  private class ArrayIteration extends PreCallGraphStep {
    override predicate loadStep(DataFlow::Node obj, DataFlow::Node element, string prop) {
      exists(DataFlow::MethodCallNode call |
        call.getMethodName() = ["map", "forEach"] and
        prop = arrayElement() and
        obj = call.getReceiver() and
        element = call.getCallback(0).getParameter(0)
      )
    }

    override predicate storeStep(DataFlow::Node element, DataFlow::SourceNode obj, string prop) {
      exists(DataFlow::MethodCallNode call |
        call.getMethodName() = "map" and
        prop = arrayElement() and
        element = call.getCallback(0).getAReturn() and
        obj = call
      )
    }

    override predicate loadStoreStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
      exists(DataFlow::MethodCallNode call |
        call.getMethodName() = ["map", "forEach"] and
        prop = arrayElement() and
        pred = call.getReceiver() and
        succ = call.getCallback(0).getParameter(2)
      )
    }
  }

  /**
   * A step for creating an array and storing the elements in the array.
   */
  private class ArrayCreationStep extends DataFlow::SharedFlowStep {
    override predicate storeStep(DataFlow::Node element, DataFlow::SourceNode obj, string prop) {
      exists(DataFlow::ArrayCreationNode array, int i |
        element = array.getElement(i) and
        obj = array and
        if array = any(PromiseAllCreation c).getArrayNode()
        then prop = arrayElement(i)
        else prop = arrayElement()
      )
    }
  }

  /**
   * A step modelling that `splice` can insert elements into an array.
   * For example in `array.splice(i, del, e)`: if `e` is tainted, then so is `array
   */
  private class ArraySpliceStep extends DataFlow::SharedFlowStep {
    override predicate storeStep(DataFlow::Node element, DataFlow::SourceNode obj, string prop) {
      exists(DataFlow::MethodCallNode call |
        call.getMethodName() = "splice" and
        prop = arrayElement() and
        element = call.getArgument(2) and
        call = obj.getAMethodCall()
      )
    }
  }

  /**
   * A step for modelling `concat`.
   * For example in `e = arr1.concat(arr2, arr3)`: if any of the `arr` is tainted, then so is `e`.
   */
  private class ArrayConcatStep extends DataFlow::SharedFlowStep {
    override predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      exists(DataFlow::MethodCallNode call |
        call.getMethodName() = "concat" and
        prop = arrayElement() and
        (pred = call.getReceiver() or pred = call.getAnArgument()) and
        succ = call
      )
    }
  }

  /**
   * A step for modelling that elements from an array `arr` also appear in the result from calling `slice`/`splice`/`filter`.
   */
  private class ArraySliceStep extends DataFlow::SharedFlowStep {
    override predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      exists(DataFlow::MethodCallNode call |
        call.getMethodName() = ["slice", "splice", "filter"] and
        prop = arrayElement() and
        pred = call.getReceiver() and
        succ = call
      )
    }
  }
}
