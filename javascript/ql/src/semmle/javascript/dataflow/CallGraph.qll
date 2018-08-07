/**
 * Provides classes for working with call graphs derived from intra-procedural data flow.
 */

import javascript
private import InferredTypes

/**
 * DEPRECATED: Use `DataFlow::InvokeNode` instead.
 *
 * A function call or `new` expression, with information about its potential callees.
 *
 * Both direct calls and reflective calls using `call` or `apply` are modelled.
 */
deprecated class CallSite extends @invokeexpr {
  InvokeExpr invk;

  CallSite() { invk = this }

  /** Gets an abstract value representing possible callees of this call site. */
  cached AbstractValue getACalleeValue() {
    result = invk.getCallee().analyze().getAValue()
  }

  /**
   * Gets the data flow node corresponding to the `i`th argument passed to the callee
   * invoked at this call site.
   *
   * For direct calls, this is the `i`th argument to the call itself: for instance,
   * for a call `f(x, y)`, the 0th argument node is `x` and the first argument node is `y`.
   *
   * For reflective calls using `call`, the 0th argument to the call denotes the
   * receiver, so argument positions are shifted by one: for instance, for a call
   * `f.call(x, y, z)`, the 0th argument node is `y` and the first argument node is `z`,
   * while `x` is not an argument node at all.
   *
   * Note that this predicate is not defined for arguments following a spread
   * argument: for instance, for a call `f(x, ...y, z)`, the 0th argument node is `x`,
   * but the position of `z` cannot be determined, hence there are no first and second
   * argument nodes.
   */
  DataFlow::AnalyzedNode getArgumentNode(int i) {
    result = invk.getArgument(i).analyze() and
    not earlierSpreadArgument(i)
  }

  /** Holds if `invk` has a spread argument at index `i` or earlier. */
  private predicate earlierSpreadArgument(int i) {
    invk.isSpreadArgument(i) or
    (earlierSpreadArgument(i-1) and i < invk.getNumArgument())
  }

  /** Gets a potential callee based on dataflow analysis results. */
  private Function getACalleeFromDataflow() {
    result = getACalleeValue().(AbstractCallable).getFunction()
  }

  /** Gets a potential callee of this call site. */
  Function getACallee() {
    result = getACalleeFromDataflow()
    or
    not exists(getACalleeFromDataflow()) and
    result = invk.getResolvedCallee()
  }

  /**
   * Holds if the approximation of possible callees for this call site is
   * affected by the given analysis incompleteness `cause`.
   */
  predicate isIndefinite(DataFlow::Incompleteness cause) {
    getACalleeValue().isIndefinite(cause)
  }

  /**
   * Holds if our approximation of possible callees for this call site is
   * likely to be imprecise.
   *
   * We currently track one specific source of imprecision: call
   * resolution relies on flow through global variables, and the flow
   * analysis finds possible callees that are not functions.
   * This usually means that a global variable is used in multiple
   * independent contexts, so tracking flow through it leads to
   * imprecision.
   */
  predicate isImprecise() {
    isIndefinite("global") and
    exists (DefiniteAbstractValue v | v = getACalleeValue() |
      not v instanceof AbstractCallable
    )
  }

  /**
   * Holds if our approximation of possible callees for this call site is
   * likely to be incomplete.
   */
  predicate isIncomplete() {
    // the flow analysis identifies a source of incompleteness other than
    // global flow (which usually leads to imprecision rather than incompleteness)
    any (DataFlow::Incompleteness cause | isIndefinite(cause)) != "global"
  }

  /**
   * Holds if our approximation of possible callees for this call site is
   * likely to be imprecise or incomplete.
   */
  predicate isUncertain() {
    isImprecise() or isIncomplete()
  }

  /**
   * Gets a textual representation of this invocation.
   */
  string toString() {
    result = this.(InvokeExpr).toString()
  }

  Location getLocation() {
    result = this.(InvokeExpr).getLocation()
  }
}

/**
 * A reflective function call using `call` or `apply`.
 */
deprecated class ReflectiveCallSite extends CallSite {
  DataFlow::AnalyzedNode callee;
  string callMode;

  ReflectiveCallSite() {
    this.(MethodCallExpr).calls(callee.asExpr(), callMode) and
    (callMode = "call" or callMode = "apply")
  }

  override AbstractValue getACalleeValue() {
    result = callee.getAValue()
  }

  override DataFlow::AnalyzedNode getArgumentNode(int i) {
    callMode = "call" and
    result = super.getArgumentNode(i+1)
  }
}
