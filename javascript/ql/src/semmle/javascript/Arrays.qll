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
  private class ArrayFunctionTaintStep extends TaintTracking::AdditionalTaintStep,
    DataFlow::CallNode {
    ArrayFunctionTaintStep() { arrayFunctionTaintStep(_, _, this) }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      arrayFunctionTaintStep(pred, succ, this)
    }
  }

  /**
   * A taint propagating data flow edge from `pred` to `succ` caused by a call `call` to a builtin array functions.
   */
  predicate arrayFunctionTaintStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::CallNode call) {
    // `array.map(function (elt, i, ary) { ... })`: if `array` is tainted, then so are
    // `elt` and `ary`; similar for `forEach`
    exists(Function f |
      call.getArgument(0).analyze().getAValue().(AbstractFunction).getFunction() = f and
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
  private class ArrayFrom extends DataFlow::AdditionalFlowStep, DataFlow::CallNode {
    ArrayFrom() { this = DataFlow::globalVarRef("Array").getAMemberCall("from") }

    override predicate loadStoreStep(
      DataFlow::Node pred, DataFlow::Node succ, string fromProp, string toProp
    ) {
      pred = this.getArgument(0) and
      succ = this and
      fromProp = arrayLikeElement() and
      toProp = arrayElement()
    }
  }

  /**
   * A step modelling an array copy where the spread operator is used.
   * The result is essentially array concatenation.
   *
   * Such a step can occur both with the `push` and `unshift` methods, or when creating a new array.
   */
  private class ArrayCopySpread extends DataFlow::AdditionalFlowStep {
    DataFlow::Node spreadArgument; // the spread argument containing the elements to be copied.
    DataFlow::Node base; // the object where the elements should be copied to.

    ArrayCopySpread() {
      exists(DataFlow::MethodCallNode mcn | mcn = this |
        mcn.getMethodName() = ["push", "unshift"] and
        spreadArgument = mcn.getASpreadArgument() and
        base = mcn.getReceiver().getALocalSource()
      )
      or
      spreadArgument = this.(DataFlow::ArrayCreationNode).getASpreadArgument() and
      base = this
    }

    override predicate loadStoreStep(
      DataFlow::Node pred, DataFlow::Node succ, string fromProp, string toProp
    ) {
      pred = spreadArgument and
      succ = base and
      fromProp = arrayLikeElement() and
      toProp = arrayElement()
    }
  }

  /**
   * A step for storing an element on an array using `arr.push(e)` or `arr.unshift(e)`.
   */
  private class ArrayAppendStep extends DataFlow::AdditionalFlowStep, DataFlow::MethodCallNode {
    ArrayAppendStep() {
      this.getMethodName() = "push" or
      this.getMethodName() = "unshift"
    }

    override predicate storeStep(DataFlow::Node element, DataFlow::SourceNode obj, string prop) {
      prop = arrayElement() and
      element = this.getAnArgument() and
      obj.getAMethodCall() = this
    }
  }

  /**
   * A step for reading/writing an element from an array inside a for-loop.
   * E.g. a read from `foo[i]` to `bar` in `for(var i = 0; i < arr.length; i++) {bar = foo[i]}`.
   */
  private class ArrayIndexingStep extends DataFlow::AdditionalFlowStep, DataFlow::Node {
    DataFlow::PropRef read;

    ArrayIndexingStep() {
      read = this and
      forex(InferredType type | type = read.getPropertyNameExpr().flow().analyze().getAType() |
        type = TTNumber()
      ) and
      exists(VarAccess i, ExprOrVarDecl init |
        i = read.getPropertyNameExpr() and init = any(ForStmt f).getInit()
      |
        i.getVariable().getADefinition() = init or
        i.getVariable().getADefinition().(VariableDeclarator).getDeclStmt() = init
      )
    }

    override predicate loadStep(DataFlow::Node obj, DataFlow::Node element, string prop) {
      prop = arrayElement() and
      obj = this.(DataFlow::PropRead).getBase() and
      element = this
    }

    override predicate storeStep(DataFlow::Node element, DataFlow::SourceNode obj, string prop) {
      prop = arrayElement() and
      element = this.(DataFlow::PropWrite).getRhs() and
      this = obj.getAPropertyWrite()
    }
  }

  /**
   * A step for retrieving an element from an array using `.pop()` or `.shift()`.
   * E.g. `array.pop()`.
   */
  private class ArrayPopStep extends DataFlow::AdditionalFlowStep, DataFlow::MethodCallNode {
    ArrayPopStep() {
      getMethodName() = "pop" or
      getMethodName() = "shift"
    }

    override predicate loadStep(DataFlow::Node obj, DataFlow::Node element, string prop) {
      prop = arrayElement() and
      obj = this.getReceiver() and
      element = this
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
  private class ArrayCreationStep extends DataFlow::AdditionalFlowStep, DataFlow::ArrayCreationNode {
    override predicate storeStep(DataFlow::Node element, DataFlow::SourceNode obj, string prop) {
      exists(int i |
        element = this.getElement(i) and
        obj = this and
        if this = any(PromiseAllCreation c).getArrayNode()
        then prop = arrayElement(i)
        else prop = arrayElement()
      )
    }
  }

  /**
   * A step modelling that `splice` can insert elements into an array.
   * For example in `array.splice(i, del, e)`: if `e` is tainted, then so is `array
   */
  private class ArraySpliceStep extends DataFlow::AdditionalFlowStep, DataFlow::MethodCallNode {
    ArraySpliceStep() { this.getMethodName() = "splice" }

    override predicate storeStep(DataFlow::Node element, DataFlow::SourceNode obj, string prop) {
      prop = arrayElement() and
      element = getArgument(2) and
      this = obj.getAMethodCall()
    }
  }

  /**
   * A step for modelling `concat`.
   * For example in `e = arr1.concat(arr2, arr3)`: if any of the `arr` is tainted, then so is `e`.
   */
  private class ArrayConcatStep extends DataFlow::AdditionalFlowStep, DataFlow::MethodCallNode {
    ArrayConcatStep() { this.getMethodName() = "concat" }

    override predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      prop = arrayElement() and
      (pred = this.getReceiver() or pred = this.getAnArgument()) and
      succ = this
    }
  }

  /**
   * A step for modelling that elements from an array `arr` also appear in the result from calling `slice`/`splice`/`filter`.
   */
  private class ArraySliceStep extends DataFlow::AdditionalFlowStep, DataFlow::MethodCallNode {
    ArraySliceStep() {
      this.getMethodName() = "slice" or
      this.getMethodName() = "splice" or
      this.getMethodName() = "filter"
    }

    override predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      prop = arrayElement() and
      pred = this.getReceiver() and
      succ = this
    }
  }

  /**
   * A step for modelling `for of` iteration on arrays.
   */
  private class ForOfStep extends PreCallGraphStep {
    override predicate loadStep(DataFlow::Node obj, DataFlow::Node e, string prop) {
      exists(ForOfStmt forOf |
        obj = forOf.getIterationDomain().flow() and
        e = DataFlow::lvalueNode(forOf.getLValue()) and
        prop = arrayElement()
      )
    }
  }
}
