private import csharp
private import cil
private import dotnet
private import DataFlowPrivate
private import DelegateDataFlow
private import semmle.code.csharp.dataflow.LibraryTypeDataFlow
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.frameworks.system.Collections
private import semmle.code.csharp.frameworks.system.collections.Generic

/**
 * Gets a source declaration of callable `c` that has a body or has
 * a flow summary.
 *
 * If the callable has both CIL and source code, return only the source
 * code version.
 */
DotNet::Callable getCallableForDataFlow(DotNet::Callable c) {
  exists(DotNet::Callable sourceDecl | sourceDecl = c.getSourceDeclaration() |
    result = sourceDecl and
    Summaries::summary(result, _, _, _, _, _)
    or
    result.hasBody() and
    if sourceDecl.getFile().fromSource()
    then
      // C# callable with C# implementation in the database
      result = sourceDecl
    else
      if sourceDecl instanceof CIL::Callable
      then
        // CIL callable with C# implementation in the database
        sourceDecl.matchesHandle(result.(Callable))
        or
        // CIL callable without C# implementation in the database
        not sourceDecl.matchesHandle(any(Callable k | k.hasBody())) and
        result = sourceDecl
      else
        // C# callable without C# implementation in the database
        sourceDecl.matchesHandle(result.(CIL::Callable))
  )
}

/**
 * Holds if callable `c` can return `e` as an `out`/`ref` value for parameter `p`.
 */
private predicate callableReturnsOutOrRef(Callable c, Parameter p, Expr e) {
  exists(Ssa::ExplicitDefinition def |
    def.getADefinition().getSource() = e and
    def.isLiveOutRefParameterDefinition(p) and
    p = c.getAParameter()
  )
}

/**
 * Holds if `cfn` corresponds to a call that can reach callable `c` using
 * additional calls, and `c` is a callable that either reads or writes to
 * a captured variable.
 */
private predicate transitiveCapturedCallTarget(ControlFlow::Nodes::ElementNode cfn, Callable c) {
  exists(Ssa::ExplicitDefinition def |
    exists(Ssa::ImplicitEntryDefinition edef |
      def.isCapturedVariableDefinitionFlowIn(edef, cfn, true)
    |
      c = edef.getCallable()
    )
    or
    exists(Ssa::ImplicitCallDefinition cdef | def.isCapturedVariableDefinitionFlowOut(cdef, true) |
      cfn = cdef.getControlFlowNode() and
      c = def.getEnclosingCallable()
    )
  )
}

cached
private module Cached {
  private import semmle.code.csharp.Caching

  cached
  newtype TReturnKind =
    TNormalReturnKind() { Stages::DataFlowStage::forceCachingInSameStage() } or
    TYieldReturnKind() or
    TOutReturnKind(int i) {
      exists(Parameter p | callableReturnsOutOrRef(_, p, _) and p.isOut() | i = p.getPosition())
    } or
    TRefReturnKind(int i) {
      exists(Parameter p | callableReturnsOutOrRef(_, p, _) and p.isRef() | i = p.getPosition())
    } or
    TImplicitCapturedReturnKind(LocalScopeVariable v) {
      exists(Ssa::ExplicitDefinition def | def.isCapturedVariableDefinitionFlowOut(_, _) |
        v = def.getSourceVariable().getAssignable()
      )
    } or
    TQualifierReturnKind()

  cached
  newtype TDataFlowCall =
    TNonDelegateCall(ControlFlow::Nodes::ElementNode cfn, DispatchCall dc) {
      cfn.getElement() = dc.getCall()
    } or
    TExplicitDelegateCall(ControlFlow::Nodes::ElementNode cfn, DelegateCall dc) {
      cfn.getElement() = dc
    } or
    TTransitiveCapturedCall(ControlFlow::Nodes::ElementNode cfn, Callable target) {
      transitiveCapturedCallTarget(cfn, target)
    } or
    TCilCall(CIL::Call call) {
      // No need to include calls that are compiled from source
      not call.getImplementation().getMethod().compiledFromSource()
    } or
    TSummaryDelegateCall(SourceDeclarationCallable c, int pos) {
      exists(CallableFlowSourceDelegateArg source |
        Summaries::summary(c, source, _, _, _, _) and
        pos = source.getArgumentIndex()
      )
      or
      exists(CallableFlowSinkDelegateArg sink |
        Summaries::summary(c, _, _, sink, _, _) and
        pos = sink.getDelegateIndex()
      )
    }

  /** Gets a viable run-time target for the call `call`. */
  cached
  DataFlowCallable viableCallable(DataFlowCall call) { result = call.getARuntimeTarget() }
}

import Cached

private module DispatchImpl {
  private import CallContext

  /**
   * Gets a viable run-time target for the delegate call `call`, requiring
   * call context `cc`.
   */
  private DataFlowCallable viableDelegateCallable(DataFlowCall call, CallContext cc) {
    result = call.(DelegateDataFlowCall).getARuntimeTarget(cc)
  }

  /**
   * Holds if the set of viable implementations that can be called by `call`
   * might be improved by knowing the call context. This is the case if the
   * call is a delegate call, or if the qualifier accesses a parameter of
   * the enclosing callable `c` (including the implicit `this` parameter).
   */
  predicate mayBenefitFromCallContext(DataFlowCall call, Callable c) {
    c = call.getEnclosingCallable() and
    (
      exists(CallContext cc | exists(viableDelegateCallable(call, cc)) |
        not cc instanceof EmptyCallContext
      )
      or
      call.(NonDelegateDataFlowCall).getDispatchCall().mayBenefitFromCallContext()
    )
  }

  /**
   * Gets a viable dispatch target of `call` in the context `ctx`. This is
   * restricted to those `call`s for which a context might make a difference.
   */
  DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) {
    exists(ArgumentCallContext cc | result = viableDelegateCallable(call, cc) |
      cc.isArgument(ctx.getExpr(), _)
    )
    or
    result =
      call
          .(NonDelegateDataFlowCall)
          .getDispatchCall()
          .getADynamicTargetInCallContext(ctx.(NonDelegateDataFlowCall).getDispatchCall())
          .getSourceDeclaration()
  }
}

import DispatchImpl

/**
 * Gets a node that can read the value returned from `call` with return kind
 * `kind`.
 */
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) { call = result.getCall(kind) }

/**
 * A return kind. A return kind describes how a value can be returned
 * from a callable.
 */
abstract class ReturnKind extends TReturnKind {
  /** Gets a textual representation of this position. */
  abstract string toString();
}

/**
 * A value returned from a callable using a `return` statement or an expression
 * body, that is, a "normal" return.
 */
class NormalReturnKind extends ReturnKind, TNormalReturnKind {
  override string toString() { result = "return" }
}

/** A value returned from a callable using a `yield return` statement. */
class YieldReturnKind extends ReturnKind, TYieldReturnKind {
  override string toString() { result = "yield return" }
}

/** A value returned from a callable using an `out` or a `ref` parameter. */
abstract class OutRefReturnKind extends ReturnKind {
  /** Gets the position of the `out`/`ref` parameter. */
  abstract int getPosition();
}

/** A value returned from a callable using an `out` parameter. */
class OutReturnKind extends OutRefReturnKind, TOutReturnKind {
  override int getPosition() { this = TOutReturnKind(result) }

  override string toString() { result = "out" }
}

/** A value returned from a callable using a `ref` parameter. */
class RefReturnKind extends OutRefReturnKind, TRefReturnKind {
  override int getPosition() { this = TRefReturnKind(result) }

  override string toString() { result = "ref" }
}

/** A value implicitly returned from a callable using a captured variable. */
class ImplicitCapturedReturnKind extends ReturnKind, TImplicitCapturedReturnKind {
  private LocalScopeVariable v;

  ImplicitCapturedReturnKind() { this = TImplicitCapturedReturnKind(v) }

  /** Gets the captured variable. */
  LocalScopeVariable getVariable() { result = v }

  override string toString() { result = "captured " + v }
}

/** A value returned through the qualifier of a call. */
class QualifierReturnKind extends ReturnKind, TQualifierReturnKind {
  override string toString() { result = "qualifier" }
}

class DataFlowCallable = DotNet::Callable;

/** A call relevant for data flow. */
abstract class DataFlowCall extends TDataFlowCall {
  /**
   * Gets a run-time target of this call. A target is always a source
   * declaration, and if the callable has both CIL and source code, only
   * the source code version is returned.
   */
  abstract DataFlowCallable getARuntimeTarget();

  /** Gets the control flow node where this call happens, if any. */
  abstract ControlFlow::Nodes::ElementNode getControlFlowNode();

  /** Gets the data flow node corresponding to this call, if any. */
  abstract DataFlow::Node getNode();

  /** Gets the enclosing callable of this call. */
  abstract DataFlowCallable getEnclosingCallable();

  /** Gets the underlying expression, if any. */
  final DotNet::Expr getExpr() { result = this.getNode().asExpr() }

  /** Gets the `i`th argument of this call. */
  final ArgumentNode getArgument(int i) { result.argumentOf(this, i) }

  /** Gets a textual representation of this call. */
  abstract string toString();

  /** Gets the location of this call. */
  abstract Location getLocation();
}

/** A non-delegate C# call relevant for data flow. */
class NonDelegateDataFlowCall extends DataFlowCall, TNonDelegateCall {
  private ControlFlow::Nodes::ElementNode cfn;
  private DispatchCall dc;

  NonDelegateDataFlowCall() { this = TNonDelegateCall(cfn, dc) }

  /** Gets the underlying call. */
  DispatchCall getDispatchCall() { result = dc }

  override DataFlowCallable getARuntimeTarget() {
    result = getCallableForDataFlow(dc.getADynamicTarget())
  }

  override ControlFlow::Nodes::ElementNode getControlFlowNode() { result = cfn }

  override DataFlow::ExprNode getNode() { result.getControlFlowNode() = cfn }

  override Callable getEnclosingCallable() { result = cfn.getEnclosingCallable() }

  override string toString() { result = cfn.toString() }

  override Location getLocation() { result = cfn.getLocation() }
}

/** A delegate call relevant for data flow. */
abstract class DelegateDataFlowCall extends DataFlowCall {
  /** Gets a viable run-time target of this call requiring call context `cc`. */
  abstract DataFlowCallable getARuntimeTarget(CallContext::CallContext cc);

  override DataFlowCallable getARuntimeTarget() { result = this.getARuntimeTarget(_) }
}

/** An explicit delegate call relevant for data flow. */
class ExplicitDelegateDataFlowCall extends DelegateDataFlowCall, TExplicitDelegateCall {
  private ControlFlow::Nodes::ElementNode cfn;
  private DelegateCall dc;

  ExplicitDelegateDataFlowCall() { this = TExplicitDelegateCall(cfn, dc) }

  override DataFlowCallable getARuntimeTarget(CallContext::CallContext cc) {
    result = getCallableForDataFlow(dc.getARuntimeTarget(cc))
  }

  override ControlFlow::Nodes::ElementNode getControlFlowNode() { result = cfn }

  override DataFlow::ExprNode getNode() { result.getControlFlowNode() = cfn }

  override Callable getEnclosingCallable() { result = cfn.getEnclosingCallable() }

  override string toString() { result = cfn.toString() }

  override Location getLocation() { result = cfn.getLocation() }
}

/**
 * A call that can reach a callable, using one or more additional calls, which
 * reads or updates a captured variable. We model such a chain of calls as just
 * a single call for performance reasons.
 */
class TransitiveCapturedDataFlowCall extends DataFlowCall, TTransitiveCapturedCall {
  private ControlFlow::Nodes::ElementNode cfn;
  private Callable target;

  TransitiveCapturedDataFlowCall() { this = TTransitiveCapturedCall(cfn, target) }

  override Callable getARuntimeTarget() { result = target }

  override ControlFlow::Nodes::ElementNode getControlFlowNode() { result = cfn }

  override DataFlow::ExprNode getNode() { none() }

  override Callable getEnclosingCallable() { result = cfn.getEnclosingCallable() }

  override string toString() { result = "[transitive] " + cfn.toString() }

  override Location getLocation() { result = cfn.getLocation() }
}

/** A CIL call relevant for data flow. */
class CilDataFlowCall extends DataFlowCall, TCilCall {
  private CIL::Call call;

  CilDataFlowCall() { this = TCilCall(call) }

  override DataFlowCallable getARuntimeTarget() {
    // There is no dispatch library for CIL, so do not consider overrides for now
    result = getCallableForDataFlow(call.getTarget())
  }

  override ControlFlow::Nodes::ElementNode getControlFlowNode() { none() }

  override DataFlow::ExprNode getNode() { result.getExpr() = call }

  override CIL::Callable getEnclosingCallable() { result = call.getEnclosingCallable() }

  override string toString() { result = call.toString() }

  override Location getLocation() { result = call.getLocation() }
}

/**
 * A delegate call inside a callable with a flow summary.
 *
 * For example, in `ints.Select(i => i + 1)` there is a call to the delegate at
 * parameter position `1` (counting the qualifier as the `0`th argument) inside
 * the method `Select`.
 */
class SummaryDelegateCall extends DelegateDataFlowCall, TSummaryDelegateCall {
  private SourceDeclarationCallable c;
  private int pos;

  SummaryDelegateCall() { this = TSummaryDelegateCall(c, pos) }

  override DataFlowCallable getARuntimeTarget(CallContext::CallContext cc) {
    exists(SummaryDelegateParameterSink p |
      p = TSummaryParameterNode(c, pos) and
      result = p.getARuntimeTarget(cc)
    )
  }

  override ControlFlow::Nodes::ElementNode getControlFlowNode() { none() }

  override DataFlow::Node getNode() { none() }

  override Callable getEnclosingCallable() { result = c }

  override string toString() { result = "[summary] delegate call, parameter " + pos + " of " + c }

  override Location getLocation() { result = c.getLocation() }
}
