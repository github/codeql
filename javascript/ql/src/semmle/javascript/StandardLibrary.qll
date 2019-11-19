/** Provides classes for working with standard library objects. */

import javascript

/**
 * A call to `Object.defineProperty`.
 */
class CallToObjectDefineProperty extends DataFlow::MethodCallNode {
  CallToObjectDefineProperty() {
    exists(GlobalVariable obj |
      obj.getName() = "Object" and
      calls(DataFlow::valueNode(obj.getAnAccess()), "defineProperty")
    )
  }

  /** Gets the data flow node denoting the object on which the property is defined. */
  DataFlow::Node getBaseObject() { result = getArgument(0) }

  /** Gets the name of the property being defined, if it can be determined. */
  string getPropertyName() { result = getArgument(1).getStringValue() }

  /** Gets the data flow node denoting the descriptor of the property being defined. */
  DataFlow::Node getPropertyDescriptor() { result = getArgument(2) }

  /**
   * Holds if there is an assignment to property `name` to the
   * attributes object on this node, and the right hand side of the
   * assignment is `rhs`.
   */
  predicate hasPropertyAttributeWrite(string name, DataFlow::Node rhs) {
    exists(DataFlow::SourceNode descriptor |
      descriptor.flowsTo(getPropertyDescriptor()) and
      descriptor.hasPropertyWrite(name, rhs)
    )
  }
}

/**
 * A direct call to `eval`.
 */
class DirectEval extends CallExpr {
  DirectEval() { getCallee().(GlobalVarAccess).getName() = "eval" }

  /** Holds if this call could affect the value of `lv`. */
  predicate mayAffect(LocalVariable lv) { getParent+() = lv.getScope().getScopeElement() }
}

/**
 * Flow analysis for `this` expressions inside a function that is called with
 * `Array.prototype.map` or a similar Array function that binds `this`.
 *
 * However, since the function could be invoked in another way, we additionally
 * still infer the ordinary abstract value.
 */
private class AnalyzedThisInArrayIterationFunction extends AnalyzedNode, DataFlow::ThisNode {
  AnalyzedNode thisSource;

  AnalyzedThisInArrayIterationFunction() {
    exists(DataFlow::MethodCallNode bindingCall, string name |
      name = "filter" or
      name = "forEach" or
      name = "map" or
      name = "some" or
      name = "every"
    |
      name = bindingCall.getMethodName() and
      2 = bindingCall.getNumArgument() and
      getBinder() = bindingCall.getCallback(0) and
      thisSource = bindingCall.getArgument(1)
    )
  }

  override AbstractValue getALocalValue() {
    result = thisSource.getALocalValue() or
    result = AnalyzedNode.super.getALocalValue()
  }
}

/**
 * A definition of a `Promise` object.
 */
abstract class PromiseDefinition extends DataFlow::SourceNode {
  /** Gets the executor function of this promise object. */
  abstract DataFlow::FunctionNode getExecutor();

  /** Gets the `resolve` parameter of the executor function. */
  DataFlow::ParameterNode getResolveParameter() { result = getExecutor().getParameter(0) }

  /** Gets the `reject` parameter of the executor function. */
  DataFlow::ParameterNode getRejectParameter() { result = getExecutor().getParameter(1) }

  /** Gets the `i`th callback handler installed by method `m`. */
  private DataFlow::FunctionNode getAHandler(string m, int i) {
    result = getAMethodCall(m).getCallback(i)
  }

  /**
   * Gets a function that handles promise resolution, including both
   * `then` handlers and `finally` handlers.
   */
  DataFlow::FunctionNode getAResolveHandler() {
    result = getAHandler("then", 0) or
    result = getAFinallyHandler()
  }

  /**
   * Gets a function that handles promise rejection, including
   * `then` handlers, `catch` handlers and `finally` handlers.
   */
  DataFlow::FunctionNode getARejectHandler() {
    result = getAHandler("then", 1) or
    result = getACatchHandler() or
    result = getAFinallyHandler()
  }

  /**
   * Gets a `catch` handler of this promise.
   */
  DataFlow::FunctionNode getACatchHandler() { result = getAHandler("catch", 0) }

  /**
   * Gets a `finally` handler of this promise.
   */
  DataFlow::FunctionNode getAFinallyHandler() { result = getAHandler("finally", 0) }
}

/** Holds if the `i`th callback handler is installed by method `m`. */
private predicate hasHandler(DataFlow::InvokeNode promise, string m, int i) {
  exists(promise.getAMethodCall(m).getCallback(i))
}

/**
 * A call that looks like a Promise.
 *
 * For example, this could be the call `promise(f).then(function(v){...})`
 */
class PromiseCandidate extends DataFlow::InvokeNode {
  PromiseCandidate() {
    hasHandler(this, "then", [0 .. 1]) or
    hasHandler(this, "catch", 0) or
    hasHandler(this, "finally", 0)
  }
}

/**
 * A promise object created by the standard ECMAScript 2015 `Promise` constructor.
 */
private class ES2015PromiseDefinition extends PromiseDefinition, DataFlow::NewNode {
  ES2015PromiseDefinition() { this = DataFlow::globalVarRef("Promise").getAnInstantiation() }

  override DataFlow::FunctionNode getExecutor() { result = getCallback(0) }
}

/**
 * A promise that is resolved with the given value.
 */
abstract class PromiseCreationCall extends DataFlow::CallNode {
  /**
   * Gets the value this promise is resolved with.
   */
  abstract DataFlow::Node getValue();
}

/**
 * A resolved promise created by the standard ECMAScript 2015 `Promise.resolve` function.
 */
class ResolvedES2015PromiseDefinition extends PromiseCreationCall {
  ResolvedES2015PromiseDefinition() {
    this = DataFlow::globalVarRef("Promise").getAMemberCall("resolve")
  }

  override DataFlow::Node getValue() { result = getArgument(0) }
}

/**
 * An aggregated promise produced either by `Promise.all` or `Promise.race`. 
 */
class AggregateES2015PromiseDefinition extends PromiseCreationCall {
  AggregateES2015PromiseDefinition() {
    exists(string m | m = "all" or m = "race" | 
      this = DataFlow::globalVarRef("Promise").getAMemberCall(m)
    )
  }

  override DataFlow::Node getValue() {
    result = getArgument(0).getALocalSource().(DataFlow::ArrayCreationNode).getAnElement()
  }
}

/**
 * A data flow edge from a promise reaction to the corresponding handler.
 */
private class PromiseFlowStep extends DataFlow::AdditionalFlowStep {
  PromiseDefinition p;

  PromiseFlowStep() { this = p }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred = p.getResolveParameter().getACall().getArgument(0) and
    succ = p.getAResolveHandler().getParameter(0)
    or
    pred = p.getRejectParameter().getACall().getArgument(0) and
    succ = p.getARejectHandler().getParameter(0)
  }
}

/**
 * Holds if taint propagates from `pred` to `succ` through promises.
 */
predicate promiseTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  // from `x` to `new Promise((res, rej) => res(x))`
  pred = succ.(PromiseDefinition).getResolveParameter().getACall().getArgument(0)
  or
  // from `x` to `Promise.resolve(x)`
  pred = succ.(PromiseCreationCall).getValue()
  or
  exists(DataFlow::MethodCallNode thn, DataFlow::FunctionNode cb |
    thn.getMethodName() = "then" and cb = thn.getCallback(0)
  |
    // from `p` to `x` in `p.then(x => ...)`
    pred = thn.getReceiver() and
    succ = cb.getParameter(0)
    or
    // from `v` to `p.then(x => return v)`
    pred = cb.getAReturn() and
    succ = thn
  )
}

/**
 * An additional taint step that involves promises.
 */
private class PromiseTaintStep extends TaintTracking::AdditionalTaintStep {
  DataFlow::Node source;

  PromiseTaintStep() { promiseTaintStep(source, this) }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred = source and succ = this
  }
}

/**
 * A flow step propagating the exception thrown from a callback to a method whose name coincides
 * a built-in Array iteration method, such as `forEach` or `map`.
 */
private class IteratorExceptionStep extends DataFlow::MethodCallNode, DataFlow::AdditionalFlowStep {
  IteratorExceptionStep() {
    exists(string name | name = getMethodName() |
      name = "forEach" or
      name = "each" or
      name = "map" or
      name = "filter" or
      name = "some" or
      name = "every" or
      name = "fold" or
      name = "reduce"
    )
  }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred = getAnArgument().(DataFlow::FunctionNode).getExceptionalReturn() and
    succ = this.getExceptionalReturn()
  }
}
