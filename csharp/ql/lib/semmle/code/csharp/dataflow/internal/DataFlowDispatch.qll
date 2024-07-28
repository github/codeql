private import csharp
private import DataFlowImplCommon as DataFlowImplCommon
private import DataFlowPublic
private import DataFlowPrivate
private import FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.csharp.dataflow.FlowSummary as FlowSummary
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.dispatch.RuntimeCallable
private import semmle.code.csharp.frameworks.system.Collections
private import semmle.code.csharp.frameworks.system.collections.Generic

/**
 * Gets a source declaration of callable `c` that has a body and is
 * defined in source.
 */
Callable getCallableForDataFlow(Callable c) {
  result = c.getUnboundDeclaration() and
  result.hasBody() and
  result.getFile().fromSource()
}

newtype TReturnKind =
  TNormalReturnKind() or
  TOutReturnKind(int i) { i = any(Parameter p | p.isOut()).getPosition() } or
  TRefReturnKind(int i) { i = any(Parameter p | p.isRef()).getPosition() }

cached
private module Cached {
  /**
   * The following heuristic is used to rank when to use source code or when to use summaries for DataFlowCallables.
   * 1. Use hand written summaries or source code.
   * 2. Use auto generated summaries.
   */
  cached
  newtype TDataFlowCallable =
    TCallable(Callable c) { c.isUnboundDeclaration() } or
    TSummarizedCallable(FlowSummary::SummarizedCallable sc) or
    TFieldOrPropertyCallable(FieldOrProperty f) or
    TCapturedVariableCallable(LocalScopeVariable v) { v.isCaptured() }

  cached
  newtype TDataFlowCall =
    TNonDelegateCall(ControlFlow::Nodes::ElementNode cfn, DispatchCall dc) {
      DataFlowImplCommon::forceCachingInSameStage() and
      cfn.getAstNode() = dc.getCall()
    } or
    TExplicitDelegateLikeCall(ControlFlow::Nodes::ElementNode cfn, DelegateLikeCall dc) {
      cfn.getAstNode() = dc
    } or
    TSummaryCall(FlowSummary::SummarizedCallable c, FlowSummaryImpl::Private::SummaryNode receiver) {
      FlowSummaryImpl::Private::summaryCallbackRange(c, receiver)
    }

  /** Gets a viable run-time target for the call `call`. */
  cached
  DataFlowCallable viableCallable(DataFlowCall call) { result = call.getARuntimeTarget() }

  cached
  newtype TParameterPosition =
    TPositionalParameterPosition(int i) { i = any(Parameter p).getPosition() } or
    TThisParameterPosition() or
    TDelegateSelfParameterPosition()

  cached
  newtype TArgumentPosition =
    TPositionalArgumentPosition(int i) { i = any(Parameter p).getPosition() } or
    TQualifierArgumentPosition() or
    TDelegateSelfArgumentPosition()
}

import Cached

private module DispatchImpl {
  private predicate mayBenefitFromCallContext(DataFlowCall call, DataFlowCallable c) {
    c = call.getEnclosingCallable() and
    call.(NonDelegateDataFlowCall).getDispatchCall().mayBenefitFromCallContext()
  }

  /**
   * Holds if the set of viable implementations that can be called by `call`
   * might be improved by knowing the call context.
   */
  predicate mayBenefitFromCallContext(DataFlowCall call) { mayBenefitFromCallContext(call, _) }

  /**
   * Gets a viable dispatch target of `call` in the context `ctx`. This is
   * restricted to those `call`s for which a context might make a difference.
   */
  DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) {
    exists(DispatchCall dc | dc = call.(NonDelegateDataFlowCall).getDispatchCall() |
      result.getUnderlyingCallable() =
        getCallableForDataFlow(dc.getADynamicTargetInCallContext(ctx.(NonDelegateDataFlowCall)
                .getDispatchCall()).getUnboundDeclaration())
      or
      exists(Callable c, DataFlowCallable encl |
        result.asSummarizedCallable() = c and
        mayBenefitFromCallContext(call, encl) and
        encl = ctx.getARuntimeTarget() and
        c = dc.getAStaticTarget().getUnboundDeclaration() and
        not c instanceof RuntimeCallable
      )
    )
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

/** A callable used for data flow. */
class DataFlowCallable extends TDataFlowCallable {
  /** Gets the underlying source code callable, if any. */
  Callable asCallable() { this = TCallable(result) }

  /** Gets the underlying summarized callable, if any. */
  FlowSummary::SummarizedCallable asSummarizedCallable() { this = TSummarizedCallable(result) }

  /** Gets the underlying field or property, if any. */
  FieldOrProperty asFieldOrProperty() { this = TFieldOrPropertyCallable(result) }

  LocalScopeVariable asCapturedVariable() { this = TCapturedVariableCallable(result) }

  /** Gets the underlying callable. */
  Callable getUnderlyingCallable() {
    result = this.asCallable() or result = this.asSummarizedCallable()
  }

  /** Gets a textual representation of this dataflow callable. */
  string toString() {
    result = this.getUnderlyingCallable().toString()
    or
    result = this.asFieldOrProperty().toString()
    or
    result = this.asCapturedVariable().toString()
  }

  /** Get the location of this dataflow callable. */
  Location getLocation() {
    result = this.getUnderlyingCallable().getLocation()
    or
    result = this.asFieldOrProperty().getLocation()
    or
    result = this.asCapturedVariable().getLocation()
  }

  /** Gets a best-effort total ordering. */
  int totalorder() {
    this =
      rank[result](DataFlowCallable c, string file, int startline, int startcolumn |
        c.getLocation().hasLocationInfo(file, startline, startcolumn, _, _)
      |
        c order by file, startline, startcolumn
      )
  }
}

/** A call relevant for data flow. */
abstract class DataFlowCall extends TDataFlowCall {
  /**
   * Gets a run-time target of this call. A target is always a source
   * declaration.
   */
  abstract DataFlowCallable getARuntimeTarget();

  /** Gets the control flow node where this call happens, if any. */
  abstract ControlFlow::Nodes::ElementNode getControlFlowNode();

  /** Gets the data flow node corresponding to this call, if any. */
  abstract DataFlow::Node getNode();

  /** Gets the enclosing callable of this call. */
  abstract DataFlowCallable getEnclosingCallable();

  /** Gets the underlying expression, if any. */
  final Expr getExpr() { result = this.getNode().asExpr() }

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

  /** Gets a best-effort total ordering. */
  int totalorder() {
    this =
      rank[result](DataFlowCall c, int startline, int startcolumn |
        c.hasLocationInfo(_, startline, startcolumn, _, _)
      |
        c order by startline, startcolumn
      )
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
    result.asCallable() = getCallableForDataFlow(dc.getADynamicTarget())
    or
    // Only use summarized callables with generated summaries in case
    // we are not able to dispatch to a source declaration.
    exists(FlowSummary::SummarizedCallable sc, boolean static |
      result.asSummarizedCallable() = sc and
      sc = this.getATarget(static) and
      not (
        sc.applyGeneratedModel() and
        dc.getADynamicTarget().getUnboundDeclaration().getFile().fromSource()
      )
    |
      static = false
      or
      static = true and not sc instanceof RuntimeCallable
    )
  }

  /** Gets a static or dynamic target of this call. */
  Callable getATarget(boolean static) {
    result = dc.getADynamicTarget().getUnboundDeclaration() and static = false
    or
    result = dc.getAStaticTarget().getUnboundDeclaration() and static = true
  }

  override ControlFlow::Nodes::ElementNode getControlFlowNode() { result = cfn }

  override DataFlow::ExprNode getNode() { result.getControlFlowNode() = cfn }

  override DataFlowCallable getEnclosingCallable() {
    result.asCallable() = cfn.getEnclosingCallable()
  }

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

  override DataFlowCallable getEnclosingCallable() {
    result.asCallable() = cfn.getEnclosingCallable()
  }

  override string toString() { result = cfn.toString() }

  override Location getLocation() { result = cfn.getLocation() }
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
  private FlowSummaryImpl::Private::SummaryNode receiver;

  SummaryCall() { this = TSummaryCall(c, receiver) }

  /** Gets the data flow node that this call targets. */
  FlowSummaryImpl::Private::SummaryNode getReceiver() { result = receiver }

  override DataFlowCallable getARuntimeTarget() {
    none() // handled by the shared library
  }

  override ControlFlow::Nodes::ElementNode getControlFlowNode() { none() }

  override DataFlow::Node getNode() { none() }

  override DataFlowCallable getEnclosingCallable() { result.asSummarizedCallable() = c }

  override string toString() { result = "[summary] call to " + receiver + " in " + c }

  override Location getLocation() { result = c.getLocation() }
}

/** A parameter position. */
class ParameterPosition extends TParameterPosition {
  /** Gets the underlying integer position, if any. */
  int getPosition() { this = TPositionalParameterPosition(result) }

  /** Holds if this position represents a `this` parameter. */
  predicate isThisParameter() { this = TThisParameterPosition() }

  /**
   * Holds if this position represents a reference to a delegate itself.
   *
   * Used for tracking flow through captured variables and for improving
   * delegate dispatch.
   */
  predicate isDelegateSelf() { this = TDelegateSelfParameterPosition() }

  /** Gets a textual representation of this position. */
  string toString() {
    result = "position " + this.getPosition()
    or
    this.isThisParameter() and result = "this"
    or
    this.isDelegateSelf() and
    result = "delegate self"
  }
}

/** An argument position. */
class ArgumentPosition extends TArgumentPosition {
  /** Gets the underlying integer position, if any. */
  int getPosition() { this = TPositionalArgumentPosition(result) }

  /** Holds if this position represents a qualifier. */
  predicate isQualifier() { this = TQualifierArgumentPosition() }

  /**
   * Holds if this position represents a reference to a delegate itself.
   *
   * Used for tracking flow through captured variables and for improving
   * delegate dispatch.
   */
  predicate isDelegateSelf() { this = TDelegateSelfArgumentPosition() }

  /** Gets a textual representation of this position. */
  string toString() {
    result = "position " + this.getPosition()
    or
    this.isQualifier() and result = "qualifier"
    or
    this.isDelegateSelf() and
    result = "delegate self"
  }
}

/** Holds if arguments at position `apos` match parameters at position `ppos`. */
predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) {
  ppos.getPosition() = apos.getPosition()
  or
  ppos.isThisParameter() and apos.isQualifier()
  or
  ppos.isDelegateSelf() and apos.isDelegateSelf()
}
