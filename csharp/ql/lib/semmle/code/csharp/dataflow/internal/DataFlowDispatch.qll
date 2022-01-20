private import csharp
private import cil
private import dotnet
private import DataFlowImplCommon as DataFlowImplCommon
private import DataFlowPublic
private import DataFlowPrivate
private import FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.csharp.dataflow.FlowSummary as FlowSummary
private import semmle.code.csharp.dataflow.ExternalFlow
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.dispatch.RuntimeCallable
private import semmle.code.csharp.frameworks.system.Collections
private import semmle.code.csharp.frameworks.system.collections.Generic

private predicate summarizedCallable(DataFlowCallable c) {
  c instanceof FlowSummary::SummarizedCallable
  or
  FlowSummaryImpl::Private::summaryReturnNode(_, TJumpReturnKind(c, _))
  or
  c = interpretElement(_, _, _, _, _, _)
}

/**
 * Gets a source declaration of callable `c` that has a body or has
 * a flow summary.
 *
 * If the callable has both CIL and source code, return only the source
 * code version.
 */
DotNet::Callable getCallableForDataFlow(DotNet::Callable c) {
  exists(DotNet::Callable unboundDecl | unboundDecl = c.getUnboundDeclaration() |
    summarizedCallable(unboundDecl) and
    result = unboundDecl
    or
    result.hasBody() and
    if unboundDecl.getFile().fromSource()
    then
      // C# callable with C# implementation in the database
      result = unboundDecl
    else
      if unboundDecl instanceof CIL::Callable
      then
        // CIL callable with C# implementation in the database
        unboundDecl.matchesHandle(result.(Callable))
        or
        // CIL callable without C# implementation in the database
        not unboundDecl.matchesHandle(any(Callable k | k.hasBody())) and
        result = unboundDecl
      else
        // C# callable without C# implementation in the database
        unboundDecl.matchesHandle(result.(CIL::Callable))
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

newtype TReturnKind =
  TNormalReturnKind() or
  TOutReturnKind(int i) { i = any(Parameter p | p.isOut()).getPosition() } or
  TRefReturnKind(int i) { i = any(Parameter p | p.isRef()).getPosition() } or
  TImplicitCapturedReturnKind(LocalScopeVariable v) {
    exists(Ssa::ExplicitDefinition def | def.isCapturedVariableDefinitionFlowOut(_, _) |
      v = def.getSourceVariable().getAssignable()
    )
  } or
  TJumpReturnKind(DataFlowCallable target, ReturnKind rk) {
    rk instanceof NormalReturnKind and
    (
      target instanceof Constructor or
      not target.getReturnType() instanceof VoidType
    )
    or
    exists(target.getParameter(rk.(OutRefReturnKind).getPosition()))
  }

private module Cached {
  cached
  newtype TDataFlowCall =
    TNonDelegateCall(ControlFlow::Nodes::ElementNode cfn, DispatchCall dc) {
      DataFlowImplCommon::forceCachingInSameStage() and
      cfn.getElement() = dc.getCall()
    } or
    TExplicitDelegateLikeCall(ControlFlow::Nodes::ElementNode cfn, DelegateLikeCall dc) {
      cfn.getElement() = dc
    } or
    TTransitiveCapturedCall(ControlFlow::Nodes::ElementNode cfn, Callable target) {
      transitiveCapturedCallTarget(cfn, target)
    } or
    TCilCall(CIL::Call call) {
      // No need to include calls that are compiled from source
      not call.getImplementation().getMethod().compiledFromSource()
    } or
    TSummaryCall(FlowSummary::SummarizedCallable c, Node receiver) {
      FlowSummaryImpl::Private::summaryCallbackRange(c, receiver)
    }

  /** Gets a viable run-time target for the call `call`. */
  cached
  DataFlowCallable viableCallable(DataFlowCall call) { result = call.getARuntimeTarget() }

  private predicate capturedWithFlowIn(LocalScopeVariable v) {
    exists(Ssa::ExplicitDefinition def | def.isCapturedVariableDefinitionFlowIn(_, _, _) |
      v = def.getSourceVariable().getAssignable()
    )
  }

  cached
  newtype TParameterPosition =
    TPositionalParameterPosition(int i) { i = any(Parameter p).getPosition() } or
    TThisParameterPosition() or
    TImplicitCapturedParameterPosition(LocalScopeVariable v) { capturedWithFlowIn(v) }

  cached
  newtype TArgumentPosition =
    TPositionalArgumentPosition(int i) { i = any(Parameter p).getPosition() } or
    TQualifierArgumentPosition() or
    TImplicitCapturedArgumentPosition(LocalScopeVariable v) { capturedWithFlowIn(v) }
}

import Cached

private module DispatchImpl {
  /**
   * Holds if the set of viable implementations that can be called by `call`
   * might be improved by knowing the call context. This is the case if the
   * call is a delegate call, or if the qualifier accesses a parameter of
   * the enclosing callable `c` (including the implicit `this` parameter).
   */
  predicate mayBenefitFromCallContext(NonDelegateDataFlowCall call, Callable c) {
    c = call.getEnclosingCallable() and
    call.getDispatchCall().mayBenefitFromCallContext()
  }

  /**
   * Gets a viable dispatch target of `call` in the context `ctx`. This is
   * restricted to those `call`s for which a context might make a difference.
   */
  DataFlowCallable viableImplInCallContext(NonDelegateDataFlowCall call, DataFlowCall ctx) {
    result =
      call.getDispatchCall()
          .getADynamicTargetInCallContext(ctx.(NonDelegateDataFlowCall).getDispatchCall())
          .getUnboundDeclaration()
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
  override string toString() { result = "normal" }
}

/** A value returned from a callable using an `out` or a `ref` parameter. */
abstract class OutRefReturnKind extends ReturnKind {
  /** Gets the position of the `out`/`ref` parameter. */
  abstract int getPosition();
}

/** A value returned from a callable using an `out` parameter. */
class OutReturnKind extends OutRefReturnKind, TOutReturnKind {
  private int pos;

  OutReturnKind() { this = TOutReturnKind(pos) }

  override int getPosition() { result = pos }

  override string toString() { result = "out parameter " + pos }
}

/** A value returned from a callable using a `ref` parameter. */
class RefReturnKind extends OutRefReturnKind, TRefReturnKind {
  private int pos;

  RefReturnKind() { this = TRefReturnKind(pos) }

  override int getPosition() { result = pos }

  override string toString() { result = "ref parameter " + pos }
}

/** A value implicitly returned from a callable using a captured variable. */
class ImplicitCapturedReturnKind extends ReturnKind, TImplicitCapturedReturnKind {
  private LocalScopeVariable v;

  ImplicitCapturedReturnKind() { this = TImplicitCapturedReturnKind(v) }

  /** Gets the captured variable. */
  LocalScopeVariable getVariable() { result = v }

  override string toString() { result = "captured " + v }
}

/**
 * A value returned through the output of another callable.
 *
 * This is currently only used to model flow summaries where data may flow into
 * one API entry point and out of another.
 */
class JumpReturnKind extends ReturnKind, TJumpReturnKind {
  private DataFlowCallable target;
  private ReturnKind rk;

  JumpReturnKind() { this = TJumpReturnKind(target, rk) }

  /** Gets the target of the jump. */
  DataFlowCallable getTarget() { result = target }

  /** Gets the return kind of the target. */
  ReturnKind getTargetReturnKind() { result = rk }

  override string toString() { result = "jump to " + target }
}

class DataFlowCallable extends DotNet::Callable {
  DataFlowCallable() { this.isUnboundDeclaration() }
}

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

  /** Gets the argument at position `pos` of this call. */
  final ArgumentNode getArgument(ArgumentPosition pos) { result.argumentOf(this, pos) }

  /** Gets a textual representation of this call. */
  abstract string toString();

  /** Gets the location of this call. */
  abstract Location getLocation();

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  final predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
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
    or
    result = dc.getAStaticTarget().getUnboundDeclaration() and
    summarizedCallable(result) and
    not result instanceof RuntimeCallable
  }

  override ControlFlow::Nodes::ElementNode getControlFlowNode() { result = cfn }

  override DataFlow::ExprNode getNode() { result.getControlFlowNode() = cfn }

  override DataFlowCallable getEnclosingCallable() { result = cfn.getEnclosingCallable() }

  override string toString() { result = cfn.toString() }

  override Location getLocation() { result = cfn.getLocation() }
}

/** A delegate call relevant for data flow. */
abstract class DelegateDataFlowCall extends DataFlowCall { }

/** An explicit delegate or function pointer call relevant for data flow. */
class ExplicitDelegateLikeDataFlowCall extends DelegateDataFlowCall, TExplicitDelegateLikeCall {
  private ControlFlow::Nodes::ElementNode cfn;
  private DelegateLikeCall dc;

  ExplicitDelegateLikeDataFlowCall() { this = TExplicitDelegateLikeCall(cfn, dc) }

  /** Gets the underlying call. */
  DelegateLikeCall getCall() { result = dc }

  override DataFlowCallable getARuntimeTarget() {
    none() // handled by the shared library
  }

  override ControlFlow::Nodes::ElementNode getControlFlowNode() { result = cfn }

  override DataFlow::ExprNode getNode() { result.getControlFlowNode() = cfn }

  override DataFlowCallable getEnclosingCallable() { result = cfn.getEnclosingCallable() }

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

  override DataFlowCallable getARuntimeTarget() { result = target }

  override ControlFlow::Nodes::ElementNode getControlFlowNode() { result = cfn }

  override DataFlow::ExprNode getNode() { none() }

  override DataFlowCallable getEnclosingCallable() { result = cfn.getEnclosingCallable() }

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

  override DataFlowCallable getEnclosingCallable() { result = call.getEnclosingCallable() }

  override string toString() { result = call.toString() }

  override Location getLocation() { result = call.getLocation() }
}

/**
 * A synthesized call inside a callable with a flow summary.
 *
 * For example, in `ints.Select(i => i + 1)` there is a call to the delegate at
 * parameter position `1` (counting the qualifier as the `0`th argument) inside
 * the method `Select`.
 */
class SummaryCall extends DelegateDataFlowCall, TSummaryCall {
  private FlowSummary::SummarizedCallable c;
  private Node receiver;

  SummaryCall() { this = TSummaryCall(c, receiver) }

  /** Gets the data flow node that this call targets. */
  Node getReceiver() { result = receiver }

  override DataFlowCallable getARuntimeTarget() {
    none() // handled by the shared library
  }

  override ControlFlow::Nodes::ElementNode getControlFlowNode() { none() }

  override DataFlow::Node getNode() { none() }

  override DataFlowCallable getEnclosingCallable() { result = c }

  override string toString() { result = "[summary] call to " + receiver + " in " + c }

  override Location getLocation() { result = c.getLocation() }
}

/** A parameter position. */
class ParameterPosition extends TParameterPosition {
  /** Gets the underlying integer position, if any. */
  int getPosition() { this = TPositionalParameterPosition(result) }

  /** Holds if this position represents a `this` parameter. */
  predicate isThisParameter() { this = TThisParameterPosition() }

  /** Holds if this position is used to model flow through captured variables. */
  predicate isImplicitCapturedParameterPosition(LocalScopeVariable v) {
    this = TImplicitCapturedParameterPosition(v)
  }

  /** Gets a textual representation of this position. */
  string toString() {
    result = "position " + this.getPosition()
    or
    this.isThisParameter() and result = "this"
    or
    exists(LocalScopeVariable v |
      this.isImplicitCapturedParameterPosition(v) and result = "captured " + v
    )
  }
}

/** An argument position. */
class ArgumentPosition extends TArgumentPosition {
  /** Gets the underlying integer position, if any. */
  int getPosition() { this = TPositionalArgumentPosition(result) }

  /** Holds if this position represents a qualifier. */
  predicate isQualifier() { this = TQualifierArgumentPosition() }

  /** Holds if this position is used to model flow through captured variables. */
  predicate isImplicitCapturedArgumentPosition(LocalScopeVariable v) {
    this = TImplicitCapturedArgumentPosition(v)
  }

  /** Gets a textual representation of this position. */
  string toString() {
    result = "position " + this.getPosition()
    or
    this.isQualifier() and result = "qualifier"
    or
    exists(LocalScopeVariable v |
      this.isImplicitCapturedArgumentPosition(v) and result = "captured " + v
    )
  }
}

/** Holds if arguments at position `apos` match parameters at position `ppos`. */
predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) {
  ppos.getPosition() = apos.getPosition()
  or
  ppos.isThisParameter() and apos.isQualifier()
  or
  exists(LocalScopeVariable v |
    ppos.isImplicitCapturedParameterPosition(v) and
    apos.isImplicitCapturedArgumentPosition(v)
  )
}
