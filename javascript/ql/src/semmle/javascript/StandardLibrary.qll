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
 * Models `Array.prototype.map` and friends as partial invocations that pass their second
 * argument as the receiver to the callback.
 */
private class ArrayIterationCallbackAsPartialInvoke extends DataFlow::PartialInvokeNode::Range,
  DataFlow::MethodCallNode {
  ArrayIterationCallbackAsPartialInvoke() {
    getNumArgument() = 2 and
    // Filter out library methods named 'forEach' etc
    not DataFlow::moduleImport(_).flowsTo(getReceiver()) and
    exists(string name | name = getMethodName() |
      name = "filter" or
      name = "forEach" or
      name = "map" or
      name = "some" or
      name = "every"
    )
  }

  override DataFlow::Node getBoundReceiver(DataFlow::Node callback) {
    callback = getArgument(0) and
    result = getArgument(1)
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

/**
 * A call to `String.prototype.replace`.
 *
 * We heuristically include any call to a method called `replace`, provided it either
 * has exactly two arguments, or local data flow suggests that the receiver may be a string.
 */
class StringReplaceCall extends DataFlow::MethodCallNode {
  StringReplaceCall() {
    getMethodName() = ["replace", "replaceAll"] and
    (getNumArgument() = 2 or getReceiver().mayHaveStringValue(_))
  }

  /** Gets the regular expression passed as the first argument to `replace`, if any. */
  DataFlow::RegExpLiteralNode getRegExp() { result.flowsTo(getArgument(0)) }

  /** Gets a string that is being replaced by this call. */
  string getAReplacedString() {
    result = getRegExp().getRoot().getAMatchedString() or
    getArgument(0).mayHaveStringValue(result)
  }

  /**
   * Gets the second argument of this call to `replace`, which is either a string
   * or a callback.
   */
  DataFlow::Node getRawReplacement() { result = getArgument(1) }

  /**
   * Gets a function flowing into the second argument of this call to `replace`.
   */
  DataFlow::FunctionNode getReplacementCallback() { result = getCallback(1) }

  /**
   * Holds if this is a global replacement, that is, the first argument is a regular expression
   * with the `g` flag, or this is a call to `.replaceAll()`.
   */
  predicate isGlobal() { getRegExp().isGlobal() or getMethodName() = "replaceAll" }

  /**
   * Holds if this call to `replace` replaces `old` with `new`.
   */
  predicate replaces(string old, string new) {
    exists(string rawNew |
      old = getAReplacedString() and
      getRawReplacement().mayHaveStringValue(rawNew) and
      new = rawNew.replaceAll("$&", old)
    )
    or
    exists(DataFlow::FunctionNode replacer, DataFlow::PropRead pr, DataFlow::ObjectLiteralNode map |
      replacer = getCallback(1) and
      replacer.getParameter(0).flowsToExpr(pr.getPropertyNameExpr()) and
      pr = map.getAPropertyRead() and
      pr.flowsTo(replacer.getAReturn()) and
      map.hasPropertyWrite(old, any(DataFlow::Node repl | repl.getStringValue() = new))
    )
  }
}

/**
 * A call to `String.prototype.split`.
 *
 * We heuristically include any call to a method called `split`, provided it either
 * has one or two arguments, or local data flow suggests that the receiver may be a string.
 */
class StringSplitCall extends DataFlow::MethodCallNode {
  StringSplitCall() {
    this.getMethodName() = "split" and
    (getNumArgument() = [1, 2] or getReceiver().mayHaveStringValue(_))
  }

  /**
   * Gets a string that determines where the string is split.
   */
  string getSeparator() {
    getArgument(0).mayHaveStringValue(result)
    or
    result =
      getArgument(0).getALocalSource().(DataFlow::RegExpCreationNode).getRoot().getAMatchedString()
  }

  /**
   * Gets the DataFlow::Node for the base string that is split.
   */
  DataFlow::Node getBaseString() { result = getReceiver() }

  /**
   * Gets a read of the `i`th element from the split string.
   */
  bindingset[i]
  DataFlow::Node getASubstringRead(int i) { result = getAPropertyRead(i.toString()) }
}
