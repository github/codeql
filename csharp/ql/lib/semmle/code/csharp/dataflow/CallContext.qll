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
