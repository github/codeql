import javascript
private import semmle.javascript.dataflow.InferredTypes

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

/**
 * Classes and predicates for modelling data-flow for arrays.
 */
private module ArrayDataFlow {
  /**
   * Gets a pseudo-field representing an element inside an array.
   */
  private string arrayElement() { result = "$arrayElement$" }

  /**
   * A step for storing an element on an array using `arr.push(e)` or `arr.unshift(e)`.
   */
  private class ArrayAppendStep extends DataFlow::AdditionalFlowStep, DataFlow::MethodCallNode {
    ArrayAppendStep() {
      this.getMethodName() = "push" or
      this.getMethodName() = "unshift"
    }

    override predicate storeStep(DataFlow::Node element, DataFlow::Node obj, string prop) {
      prop = arrayElement() and
      (element = this.getAnArgument() or element = this.getASpreadArgument()) and
      obj = this.getReceiver().getALocalSource()
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

    override predicate storeStep(DataFlow::Node element, DataFlow::Node obj, string prop) {
      prop = arrayElement() and
      element = this.(DataFlow::PropWrite).getRhs() and
      this = obj.(DataFlow::SourceNode).getAPropertyWrite()
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
  private class ArrayIteration extends DataFlow::AdditionalFlowStep, DataFlow::MethodCallNode {
    ArrayIteration() {
      this.getMethodName() = "map" or
      this.getMethodName() = "forEach"
    }

    override predicate loadStep(DataFlow::Node obj, DataFlow::Node element, string prop) {
      prop = arrayElement() and
      obj = this.getReceiver() and
      element = getCallback(0).getParameter(0)
    }

    override predicate storeStep(DataFlow::Node element, DataFlow::Node obj, string prop) {
      this.getMethodName() = "map" and
      prop = arrayElement() and
      element = this.getCallback(0).getAReturn() and
      obj = this
    }

    override predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      prop = arrayElement() and
      pred = this.getReceiver() and
      succ = getCallback(0).getParameter(2)
    }
  }

  /**
   * A step for creating an array and storing the elements in the array.
   */
  private class ArrayCreationStep extends DataFlow::AdditionalFlowStep, DataFlow::Node {
    ArrayCreationStep() { this instanceof DataFlow::ArrayCreationNode }

    override predicate storeStep(DataFlow::Node element, DataFlow::Node obj, string prop) {
      prop = arrayElement() and
      element = this.(DataFlow::ArrayCreationNode).getAnElement() and
      obj = this
    }
  }

  /**
   * A step modelling that `splice` can insert elements into an array.
   * For example in `array.splice(i, del, e)`: if `e` is tainted, then so is `array
   */
  private class ArraySpliceStep extends DataFlow::AdditionalFlowStep, DataFlow::MethodCallNode {
    ArraySpliceStep() { this.getMethodName() = "splice" }

    override predicate storeStep(DataFlow::Node element, DataFlow::Node obj, string prop) {
      prop = arrayElement() and
      element = getArgument(2) and
      obj = this.getReceiver().getALocalSource()
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
}
