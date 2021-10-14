/**
 * DEPRECATED.
 *
 * Provides classes for data flow call contexts.
 */

import csharp
private import semmle.code.csharp.dataflow.internal.DelegateDataFlow
private import semmle.code.csharp.dispatch.Dispatch

// Internal representation of call contexts
cached
private newtype TCallContext =
  TEmptyCallContext() or
  TArgNonDelegateCallContext(Expr arg) { exists(DispatchCall dc | arg = dc.getArgument(_)) } or
  TArgDelegateCallContext(DelegateCall dc, int i) { exists(dc.getArgument(i)) } or
  TArgFunctionPointerCallContext(FunctionPointerCall fptrc, int i) { exists(fptrc.getArgument(i)) }

/**
 * DEPRECATED.
 *
 * A call context.
 *
 * A call context records the origin of data flow into callables.
 */
deprecated class CallContext extends TCallContext {
  /** Gets a textual representation of this call context. */
  string toString() { none() }

  /** Gets the location of this call context, if any. */
  Location getLocation() { none() }
}

/** DEPRECATED. An empty call context. */
deprecated class EmptyCallContext extends CallContext, TEmptyCallContext {
  override string toString() { result = "<empty>" }

  override EmptyLocation getLocation() { any() }
}

/**
 * DEPRECATED.
 *
 * An argument call context, that is a call argument through which data flows
 * into a callable.
 */
abstract deprecated class ArgumentCallContext extends CallContext {
  /**
   * Holds if this call context represents the argument at position `i` of the
   * call expression `call`.
   */
  abstract predicate isArgument(Expr call, int i);
}

/** DEPRECATED. An argument of a non-delegate call. */
deprecated class NonDelegateCallArgumentCallContext extends ArgumentCallContext,
  TArgNonDelegateCallContext {
  Expr arg;

  NonDelegateCallArgumentCallContext() { this = TArgNonDelegateCallContext(arg) }

  override predicate isArgument(Expr call, int i) {
    exists(DispatchCall dc | arg = dc.getArgument(i) | call = dc.getCall())
  }

  override string toString() { result = arg.toString() }

  override Location getLocation() { result = arg.getLocation() }
}

/** DEPRECATED. An argument of a delegate or function pointer call. */
deprecated class DelegateLikeCallArgumentCallContext extends ArgumentCallContext {
  DelegateLikeCall dc;
  int arg;

  DelegateLikeCallArgumentCallContext() {
    this = TArgDelegateCallContext(dc, arg) or this = TArgFunctionPointerCallContext(dc, arg)
  }

  override predicate isArgument(Expr call, int i) {
    call = dc and
    i = arg
  }

  override string toString() { result = dc.getArgument(arg).toString() }

  override Location getLocation() { result = dc.getArgument(arg).getLocation() }
}

/** DEPRECATED. An argument of a delegate call. */
deprecated class DelegateCallArgumentCallContext extends DelegateLikeCallArgumentCallContext,
  TArgDelegateCallContext { }

/** DEPRECATED. An argument of a function pointer call. */
deprecated class FunctionPointerCallArgumentCallContext extends DelegateLikeCallArgumentCallContext,
  TArgFunctionPointerCallContext { }
