/**
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
  TArgDelegateCallContext(DelegateCall dc, int i) { exists(dc.getArgument(i)) }

/**
 * A call context.
 *
 * A call context records the origin of data flow into callables.
 */
class CallContext extends TCallContext {
  /** Gets a textual representation of this call context. */
  string toString() { none() }

  /** Gets the location of this call context, if any. */
  Location getLocation() { none() }
}

/** An empty call context. */
class EmptyCallContext extends CallContext, TEmptyCallContext {
  override string toString() { result = "<empty>" }

  override EmptyLocation getLocation() { any() }
}

/**
 * An argument call context, that is a call argument through which data flows
 * into a callable.
 */
abstract class ArgumentCallContext extends CallContext {
  /**
   * Holds if this call context represents the argument at position `i` of the
   * call expression `call`.
   */
  abstract predicate isArgument(Expr call, int i);
}

/** An argument of a non-delegate call. */
class NonDelegateCallArgumentCallContext extends ArgumentCallContext, TArgNonDelegateCallContext {
  Expr arg;

  NonDelegateCallArgumentCallContext() { this = TArgNonDelegateCallContext(arg) }

  override predicate isArgument(Expr call, int i) {
    exists(DispatchCall dc | arg = dc.getArgument(i) | call = dc.getCall())
  }

  override string toString() { result = arg.toString() }

  override Location getLocation() { result = arg.getLocation() }
}

/** An argument of a delegate call. */
class DelegateCallArgumentCallContext extends ArgumentCallContext, TArgDelegateCallContext {
  DelegateCall dc;
  int arg;

  DelegateCallArgumentCallContext() { this = TArgDelegateCallContext(dc, arg) }

  override predicate isArgument(Expr call, int i) {
    call = dc and
    i = arg
  }

  override string toString() { result = dc.getArgument(arg).toString() }

  override Location getLocation() { result = dc.getArgument(arg).getLocation() }
}
