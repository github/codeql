/**
 * DEPRECATED.
 *
 * INTERNAL: Do not use.
 *
 * Provides classes for resolving delegate calls.
 */

import csharp
private import dotnet
private import semmle.code.csharp.dataflow.CallContext
private import semmle.code.csharp.dataflow.internal.DataFlowDispatch
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.dataflow.internal.DataFlowPublic
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.frameworks.system.linq.Expressions

/** A source of flow for a delegate or function pointer expression. */
abstract private class DelegateLikeFlowSource extends DataFlow::ExprNode {
  /** Gets the callable that is referenced in this delegate or function pointer flow source. */
  abstract Callable getCallable();
}

/** A source of flow for a delegate expression. */
private class DelegateFlowSource extends DelegateLikeFlowSource {
  Callable c;

  DelegateFlowSource() {
    this.getExpr() =
      any(Expr e |
        c = e.(AnonymousFunctionExpr) or
        c = e.(CallableAccess).getTarget().getUnboundDeclaration()
      )
  }

  /** Gets the callable that is referenced in this delegate flow source. */
  override Callable getCallable() { result = c }
}

/** A source of flow for a function pointer expression. */
private class FunctionPointerFlowSource extends DelegateLikeFlowSource {
  Callable c;

  FunctionPointerFlowSource() {
    c =
      this.getExpr()
          .(AddressOfExpr)
          .getOperand()
          .(CallableAccess)
          .getTarget()
          .getUnboundDeclaration()
  }

  /** Gets the callable that is referenced in this function pointer flow source. */
  override Callable getCallable() { result = c }
}

/** A sink of flow for a delegate or function pointer expression. */
abstract private class DelegateLikeFlowSink extends DataFlow::Node { }

/** A non-delegate call. */
private class NonDelegateCall extends Expr {
  private DispatchCall dc;

  NonDelegateCall() { this = dc.getCall() }

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

pragma[noinline]
private predicate flowIntoNonDelegateCall(NonDelegateCall call, Expr arg, DotNet::Parameter p) {
  exists(DotNet::Callable callable, int i |
    callable = call.getARuntimeTarget() and
    p = callable.getAParameter() and
    arg = call.getArgument(i) and
    i = p.getPosition()
  )
}

pragma[noinline]
private predicate flowOutOfNonDelegateCall(NonDelegateCall call, NormalReturnNode ret) {
  call.getARuntimeTarget() = ret.getEnclosingCallable()
}
