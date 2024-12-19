/** Provides classes for working with standard library objects. */

import javascript

/**
 * A call to `Object.defineProperty`.
 */
class CallToObjectDefineProperty extends DataFlow::MethodCallNode {
  CallToObjectDefineProperty() {
    exists(GlobalVariable obj |
      obj.getName() = "Object" and
      this.calls(DataFlow::valueNode(obj.getAnAccess()), "defineProperty")
    )
  }

  /** Gets the data flow node denoting the object on which the property is defined. */
  DataFlow::Node getBaseObject() { result = this.getArgument(0) }

  /** Gets the name of the property being defined, if it can be determined. */
  string getPropertyName() { result = this.getArgument(1).getStringValue() }

  /** Gets the data flow node denoting the descriptor of the property being defined. */
  DataFlow::Node getPropertyDescriptor() { result = this.getArgument(2) }

  /**
   * Holds if there is an assignment to property `name` to the
   * attributes object on this node, and the right hand side of the
   * assignment is `rhs`.
   */
  predicate hasPropertyAttributeWrite(string name, DataFlow::Node rhs) {
    exists(DataFlow::SourceNode descriptor |
      descriptor.flowsTo(this.getPropertyDescriptor()) and
      descriptor.hasPropertyWrite(name, rhs)
    )
  }
}

/**
 * A direct call to `eval`.
 */
class DirectEval extends CallExpr {
  DirectEval() { this.getCallee().(GlobalVarAccess).getName() = "eval" }

  /** Holds if this call could affect the value of `lv`. */
  predicate mayAffect(LocalVariable lv) { this.getParent+() = lv.getScope().getScopeElement() }
}

/**
 * Models `Array.prototype.map` and friends as partial invocations that pass their second
 * argument as the receiver to the callback.
 */
private class ArrayIterationCallbackAsPartialInvoke extends DataFlow::PartialInvokeNode::Range,
  DataFlow::MethodCallNode
{
  ArrayIterationCallbackAsPartialInvoke() {
    this.getNumArgument() = 2 and
    // Filter out library methods named 'forEach' etc
    not DataFlow::moduleImport(_).flowsTo(this.getReceiver()) and
    this.getMethodName() = ["filter", "forEach", "map", "some", "every"]
  }

  override DataFlow::Node getBoundReceiver(DataFlow::Node callback) {
    callback = this.getArgument(0) and
    result = this.getArgument(1)
  }
}

/**
 * A flow step propagating the exception thrown from a callback to a method whose name coincides
 * a built-in Array iteration method, such as `forEach` or `map`.
 */
private class IteratorExceptionStep extends DataFlow::LegacyFlowStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::MethodCallNode call |
      call.getMethodName() = ["forEach", "each", "map", "filter", "some", "every", "fold", "reduce"] and
      pred = call.getAnArgument().(DataFlow::FunctionNode).getExceptionalReturn() and
      succ = call.getExceptionalReturn()
    )
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
    this.getMethodName() = ["replace", "replaceAll"] and
    (this.getNumArgument() = 2 or this.getReceiver().mayHaveStringValue(_))
  }

  /** Gets the regular expression passed as the first argument to `replace`, if any. */
  DataFlow::RegExpCreationNode getRegExp() { result.flowsTo(this.getArgument(0)) }

  /** Gets a string that is being replaced by this call. */
  string getAReplacedString() {
    result = this.getRegExp().getRoot().getAMatchedString() or
    this.getArgument(0).mayHaveStringValue(result)
  }

  /**
   * Gets the second argument of this call to `replace`, which is either a string
   * or a callback.
   */
  DataFlow::Node getRawReplacement() { result = this.getArgument(1) }

  /**
   * Gets a function flowing into the second argument of this call to `replace`.
   */
  DataFlow::FunctionNode getReplacementCallback() { result = this.getCallback(1) }

  /**
   * Holds if this is a global replacement, that is, the first argument is a regular expression
   * with the `g` flag, or this is a call to `.replaceAll()`.
   */
  predicate isGlobal() { this.getRegExp().isGlobal() or this.getMethodName() = "replaceAll" }

  /**
   * Holds if this is a global replacement, that is, the first argument is a regular expression
   * with the `g` flag or unknown flags, or this is a call to `.replaceAll()`.
   */
  predicate maybeGlobal() { this.getRegExp().maybeGlobal() or this.getMethodName() = "replaceAll" }

  /**
   * Holds if this call to `replace` replaces `old` with `new`.
   */
  predicate replaces(string old, string new) {
    exists(string rawNew |
      old = this.getAReplacedString() and
      this.getRawReplacement().mayHaveStringValue(rawNew) and
      new = rawNew.replaceAll("$&", old)
    )
    or
    exists(DataFlow::FunctionNode replacer, DataFlow::PropRead pr, DataFlow::ObjectLiteralNode map |
      replacer = this.getCallback(1) and
      replacer.getParameter(0).flowsToExpr(pr.getPropertyNameExpr()) and
      pr = map.getAPropertyRead() and
      pr.flowsTo(replacer.getAReturn()) and
      map.hasPropertyWrite(old, any(DataFlow::Node repl | repl.getStringValue() = new))
    )
    or
    // str.replace(regex, match => {
    //   if (match === 'old') return 'new';
    //   if (match === 'foo') return 'bar';
    //   ...
    // })
    exists(
      DataFlow::FunctionNode replacer, ConditionGuardNode guard, EqualityTest test,
      DataFlow::Node ret
    |
      replacer = this.getCallback(1) and
      guard.getOutcome() = test.getPolarity() and
      guard.getTest() = test and
      replacer.getParameter(0).flowsToExpr(test.getAnOperand()) and
      test.getAnOperand().getStringValue() = old and
      ret = replacer.getAReturn() and
      guard.dominates(ret.getBasicBlock()) and
      new = ret.getStringValue()
    )
  }

  /**
   * Holds if this call takes a regexp containing a wildcard-like term such as `.`.
   *
   * Also see `RegExp::isWildcardLike`.
   */
  final predicate hasRegExpContainingWildcard() {
    RegExp::isWildcardLike(this.getRegExp().getRoot().getAChild*())
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
    (this.getNumArgument() = [1, 2] or this.getReceiver().mayHaveStringValue(_))
  }

  /**
   * Gets a string that determines where the string is split.
   */
  string getSeparator() {
    this.getArgument(0).mayHaveStringValue(result)
    or
    result =
      this.getArgument(0)
          .getALocalSource()
          .(DataFlow::RegExpCreationNode)
          .getRoot()
          .getAMatchedString()
  }

  /**
   * Gets the DataFlow::Node for the base string that is split.
   */
  DataFlow::Node getBaseString() { result = this.getReceiver() }

  /**
   * Gets a read of the `i`th element from the split string.
   */
  bindingset[i]
  DataFlow::Node getASubstringRead(int i) { result = this.getAPropertyRead(i.toString()) }
}

/**
 * A call to `Object.prototype.hasOwnProperty`, `Object.hasOwn`, or a library that implements
 * the same functionality.
 */
class HasOwnPropertyCall extends DataFlow::Node instanceof DataFlow::CallNode {
  DataFlow::Node object;
  DataFlow::Node property;

  HasOwnPropertyCall() {
    // Make sure we handle reflective calls since libraries love to do that.
    super.getCalleeNode().getALocalSource().(DataFlow::PropRead).getPropertyName() =
      "hasOwnProperty" and
    object = super.getReceiver() and
    property = super.getArgument(0)
    or
    this =
      [
        DataFlow::globalVarRef("Object").getAMemberCall("hasOwn"), //
        DataFlow::moduleImport("has").getACall(), //
        LodashUnderscore::member("has").getACall()
      ] and
    object = super.getArgument(0) and
    property = super.getArgument(1)
  }

  /** Gets the object whose property is being checked. */
  DataFlow::Node getObject() { result = object }

  /** Gets the property being checked. */
  DataFlow::Node getProperty() { result = property }
}
