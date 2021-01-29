/**
 * INTERNAL: Do not use.
 *
 * Provides classes for resolving function pointer calls.
 */

import csharp
private import dotnet
private import semmle.code.csharp.dataflow.CallContext
private import semmle.code.csharp.dataflow.internal.DataFlowDispatch
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.dataflow.internal.DataFlowPublic
private import semmle.code.csharp.dataflow.FlowSummary
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.frameworks.system.linq.Expressions

/** A source of flow for a function pointer expression. */
private class FunctionPointerFlowSource extends DataFlow::ExprNode {
  Callable c;

  FunctionPointerFlowSource() {
    this.getExpr() =
      any(Expr e |
        c = e.(AddressOfExpr).getOperand().(CallableAccess).getTarget().getUnboundDeclaration()
      )
  }

  /** Gets the callable that is referenced in this function pointer flow source. */
  Callable getCallable() { result = c }
}

/** A sink of flow for a function pointer expression. */
abstract private class FunctionPointerFlowSink extends DataFlow::Node {
  /**
   * Gets an actual run-time target of this function pointer call in the given call
   * context, if any. The call context records the *last* call required to
   * resolve the target, if any.
   *
   * See examples in `DelegateFlowSink`.
   */
  cached
  Callable getARuntimeTarget(CallContext context) {
    exists(FunctionPointerFlowSource fptrfs |
      flowsFrom(this, fptrfs, _, context) and
      result = fptrfs.getCallable()
    )
  }
}

/** A function pointer call expression. */
class FunctionPointerCallExpr extends FunctionPointerFlowSink, DataFlow::ExprNode {
  FunctionPointerCall fptrc;

  FunctionPointerCallExpr() { this.getExpr() = fptrc.getFunctionPointerExpr() }

  /** Gets the function pointer call that this expression belongs to. */
  FunctionPointerCall getFunctionPointerCall() { result = fptrc }
}

/** A non-function pointer call. */
private class NonFunctionPointerCall extends Expr {
  private DispatchCall dc;

  NonFunctionPointerCall() { this = dc.getCall() }

  /**
   * Gets a run-time target of this call. A target is always a source
   * declaration, and if the callable has both CIL and source code, only
   * the source code version is returned.
   */
  Callable getARuntimeTarget() { result = getCallableForDataFlow(dc.getADynamicTarget()) }

  /** Gets the `i`th argument of this call. */
  Expr getArgument(int i) { result = dc.getArgument(i) }
}

private class NormalReturnNode extends Node {
  NormalReturnNode() { this.(ReturnNode).getKind() instanceof NormalReturnKind }
}

/**
 * Holds if data can flow (inter-procedurally) to function pointer `sink` from
 * `node`. This predicate searches backwards from `sink` to `node`.
 *
 * The parameter `isReturned` indicates whether the path from `sink` to
 * `node` goes through a returned expression. The call context `lastCall`
 * records the last call on the path from `node` to `sink`, if any.
 */
private predicate flowsFrom(
  FunctionPointerFlowSink sink, DataFlow::Node node, boolean isReturned, CallContext lastCall
) {
  // Base case
  sink = node and
  isReturned = false and
  lastCall instanceof EmptyCallContext
  or
  // Local flow
  exists(DataFlow::Node mid | flowsFrom(sink, mid, isReturned, lastCall) |
    LocalFlow::localFlowStepCommon(node, mid)
    or
    exists(Ssa::Definition def |
      LocalFlow::localSsaFlowStep(def, node, mid) and
      LocalFlow::usesInstanceField(def)
    )
  )
  or
  // Flow through static field or property
  exists(DataFlow::Node mid |
    flowsFrom(sink, mid, _, _) and
    jumpStep(node, mid) and
    isReturned = false and
    lastCall instanceof EmptyCallContext
  )
  or
  // Flow into a callable (non-function pointer call)
  exists(ParameterNode mid, CallContext prevLastCall, NonFunctionPointerCall call, Parameter p |
    flowsFrom(sink, mid, isReturned, prevLastCall) and
    isReturned = false and
    p = mid.getParameter() and
    flowIntoNonFunctionPointerCall(call, node.asExpr(), p) and
    lastCall = getLastCall(prevLastCall, call, p.getPosition())
  )
  or
  // Flow into a callable (function pointer call)
  exists(
    ParameterNode mid, CallContext prevLastCall, FunctionPointerCall call, Callable c, Parameter p,
    int i
  |
    flowsFrom(sink, mid, isReturned, prevLastCall) and
    isReturned = false and
    flowIntoFunctionPointerCall(call, c, node.asExpr(), i) and
    c.getParameter(i) = p and
    p = mid.getParameter() and
    lastCall = getLastCall(prevLastCall, call, i)
  )
  or
  // Flow out of a callable (non-function pointer call).
  exists(DataFlow::ExprNode mid |
    flowsFrom(sink, mid, _, lastCall) and
    isReturned = true and
    flowOutOfNonFunctionPointerCall(mid.getExpr(), node)
  )
  or
  // Flow out of a callable (function pointer call).
  exists(DataFlow::ExprNode mid |
    flowsFrom(sink, mid, _, _) and
    isReturned = true and
    flowOutOfFunctionPointerCall(mid.getExpr(), node, lastCall)
  )
}

/**
 * Gets the last call when tracking flow into `call`. The context
 * `prevLastCall` is the previous last call, so the result is the
 * previous call if it exists, otherwise `call` is the last call.
 */
bindingset[call, i]
private CallContext getLastCall(CallContext prevLastCall, Expr call, int i) {
  prevLastCall instanceof EmptyCallContext and
  result.(ArgumentCallContext).isArgument(call, i)
  or
  prevLastCall instanceof ArgumentCallContext and
  result = prevLastCall
}

pragma[noinline]
private predicate flowIntoNonFunctionPointerCall(
  NonFunctionPointerCall call, Expr arg, DotNet::Parameter p
) {
  exists(DotNet::Callable callable, int i |
    callable = call.getARuntimeTarget() and
    p = callable.getAParameter() and
    arg = call.getArgument(i) and
    i = p.getPosition()
  )
}

pragma[noinline]
private predicate flowIntoFunctionPointerCall(FunctionPointerCall call, Callable c, Expr arg, int i) {
  exists(FunctionPointerFlowSource fptrfs, FunctionPointerCallExpr fptrce |
    // the call context is irrelevant because the function pointer call
    // itself will be the context
    flowsFrom(fptrce, fptrfs, _, _) and
    arg = call.getArgument(i) and
    c = fptrfs.getCallable() and
    call = fptrce.getFunctionPointerCall()
  )
}

pragma[noinline]
private predicate flowOutOfNonFunctionPointerCall(NonFunctionPointerCall call, NormalReturnNode ret) {
  call.getARuntimeTarget() = ret.getEnclosingCallable()
}

pragma[noinline]
private predicate flowOutOfFunctionPointerCall(
  FunctionPointerCall call, NormalReturnNode ret, CallContext lastCall
) {
  exists(FunctionPointerFlowSource fptrfs, FunctionPointerCallExpr fptrce, Callable c |
    flowsFrom(fptrce, fptrfs, _, lastCall) and
    ret.getEnclosingCallable() = c and
    c = fptrfs.getCallable() and
    call = fptrce.getFunctionPointerCall()
  )
}
