/**
 * Provides classes for data flow call contexts.
 */

import csharp
private import semmle.code.csharp.dataflow.DelegateDataFlow
private import dotnet

// Internal representation of call contexts
cached
private newtype TCallContext =
  TEmptyCallContext() or
  TArgCallContext(DotNet::Call c, int i) { exists(c.getArgument(i)) } or
  TDynamicAccessorArgCallContext(DynamicAccessorCall dac, int i) { exists(dac.getArgument(i)) } or
  TDelegateToLibraryCallableArgCallContext(DelegateArgumentToLibraryCallable arg, int i) {
    exists(arg.getDelegateType().getParameter(i))
  }

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
  abstract predicate isArgument(DotNet::Expr call, int i);
}

/** An argument of an ordinary call. */
class CallArgumentCallContext extends ArgumentCallContext, TArgCallContext {
  DotNet::Call c;

  int arg;

  CallArgumentCallContext() { this = TArgCallContext(c, arg) }

  override predicate isArgument(DotNet::Expr call, int i) {
    call = c and
    i = arg
  }

  override string toString() { result = c.getArgument(arg).toString() }

  override Location getLocation() { result = c.getArgument(arg).getLocation() }
}

/** An argument of a dynamic accessor call. */
class DynamicAccessorArgumentCallContext extends ArgumentCallContext, TDynamicAccessorArgCallContext {
  DynamicAccessorCall dac;

  int arg;

  DynamicAccessorArgumentCallContext() { this = TDynamicAccessorArgCallContext(dac, arg) }

  override predicate isArgument(DotNet::Expr call, int i) {
    call = dac and
    i = arg
  }

  override string toString() { result = dac.getArgument(arg).toString() }

  override Location getLocation() { result = dac.getArgument(arg).getLocation() }
}

/**
 * An argument of a call to a delegate supplied to a library callable,
 * identified by the delegate argument itself.
 *
 * For example, in `x.Select(y => y)` the call to the supplied delegate
 * that happens inside the library callable `Select` is not available
 * in the database, so the delegate argument `y => y` is used to
 * represent the call.
 */
class DelegateArgumentToLibraryCallableArgumentContext extends ArgumentCallContext,
  TDelegateToLibraryCallableArgCallContext {
  DotNet::Expr delegate;

  int arg;

  DelegateArgumentToLibraryCallableArgumentContext() {
    this = TDelegateToLibraryCallableArgCallContext(delegate, arg)
  }

  override predicate isArgument(DotNet::Expr call, int i) {
    call = delegate and
    i = arg
  }

  override string toString() { result = "argument " + arg + " of " + delegate.toString() }

  override Location getLocation() { result = delegate.getLocation() }
}
