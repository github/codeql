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
private import semmle.code.csharp.internal.Location

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

private predicate hasMultipleSourceLocations(Callable c) { strictcount(getASourceLocation(c)) > 1 }

private module NearestBodyLocationInput implements NearestLocationInputSig {
  class C = ControlFlowElement;

  predicate relevantLocations(ControlFlowElement body, Location l1, Location l2) {
    exists(Callable c |
      hasMultipleSourceLocations(c) and
      l1 = getASourceLocation(c) and
      body = c.getBody() and
      l2 = body.getLocation()
    )
  }
}

cached
private module Cached {
  /**
   * The following heuristic is used to rank when to use source code or when to use summaries for DataFlowCallables.
   * 1. Use hand written summaries or source code.
   * 2. Use auto generated summaries.
   */
  cached
  newtype TDataFlowCallable =
    TCallable(Callable c, Location l) {
      c.isUnboundDeclaration() and
      l = [c.getLocation(), getASourceLocation(c)] and
      (
        not hasMultipleSourceLocations(c)
        or
        // when `c` has multiple source locations, only use those with a body;
        // for example, `partial` methods may have multiple source locations but
        // we are only interested in the one with a body
        NearestLocation<NearestBodyLocationInput>::nearestLocation(_, l, _)
      )
    } or
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

  bindingset[dc, result]
  pragma[inline_late]
  private Callable viableImplInCallContext0(DispatchCall dc, NonDelegateDataFlowCall ctx) {
    result = dc.getADynamicTargetInCallContext(ctx.getDispatchCall()).getUnboundDeclaration()
  }

  /**
   * Gets a viable dispatch target of `call` in the context `ctx`. This is
   * restricted to those `call`s for which a context might make a difference.
   */
  DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) {
    exists(DispatchCall dc, Callable c | dc = call.(NonDelegateDataFlowCall).getDispatchCall() |
      result = call.getARuntimeTarget() and
      getCallableForDataFlow(c) = result.asCallable(_) and
      c = viableImplInCallContext0(dc, ctx)
      or
      exists(DataFlowCallable encl |
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
  Callable asCallable(Location l) { this = TCallable(result, l) }

  /** Holds if the underlying callable is multi-bodied. */
  pragma[nomagic]
  predicate isMultiBodied() {
    exists(Location l1, Location l2, DataFlowCallable other |
      this.asCallable(l1) = other.asCallable(l2) and
      l1 != l2
    )
  }

  pragma[nomagic]
  private ControlFlow::Nodes::ElementNode getAMultiBodyEntryNode(ControlFlow::BasicBlock bb, int i) {
    this.isMultiBodied() and
    exists(ControlFlowElement body, Location l |
      body = this.asCallable(l).getBody() and
      NearestLocation<NearestBodyLocationInput>::nearestLocation(body, l, _) and
      result = body.getAControlFlowEntryNode()
    ) and
    bb.getNode(i) = result
  }

  pragma[nomagic]
  private ControlFlow::Nodes::ElementNode getAMultiBodyControlFlowNodePred() {
    result = this.getAMultiBodyEntryNode(_, _).getAPredecessor()
    or
    result = this.getAMultiBodyControlFlowNodePred().getAPredecessor()
  }

  pragma[nomagic]
  private ControlFlow::Nodes::ElementNode getAMultiBodyControlFlowNodeSuccSameBasicBlock() {
    exists(ControlFlow::BasicBlock bb, int i, int j |
      exists(this.getAMultiBodyEntryNode(bb, i)) and
      result = bb.getNode(j) and
      j > i
    )
  }

  pragma[nomagic]
  private ControlFlow::BasicBlock getAMultiBodyBasicBlockSucc() {
    result = this.getAMultiBodyEntryNode(_, _).getBasicBlock().getASuccessor()
    or
    result = this.getAMultiBodyBasicBlockSucc().getASuccessor()
  }

  pragma[inline]
  private ControlFlow::Nodes::ElementNode getAMultiBodyControlFlowNode() {
    result =
      [
        this.getAMultiBodyEntryNode(_, _), this.getAMultiBodyControlFlowNodePred(),
        this.getAMultiBodyControlFlowNodeSuccSameBasicBlock(),
        this.getAMultiBodyBasicBlockSucc().getANode()
      ]
  }

  /** Gets a control flow node belonging to this callable. */
  pragma[inline]
  ControlFlow::Node getAControlFlowNode() {
    result = this.getAMultiBodyControlFlowNode()
    or
    not this.isMultiBodied() and
    result.getEnclosingCallable() = this.asCallable(_)
  }

  /** Gets the underlying summarized callable, if any. */
  FlowSummary::SummarizedCallable asSummarizedCallable() { this = TSummarizedCallable(result) }

  /** Gets the underlying field or property, if any. */
  FieldOrProperty asFieldOrProperty() { this = TFieldOrPropertyCallable(result) }

  LocalScopeVariable asCapturedVariable() { this = TCapturedVariableCallable(result) }

  /** Gets the underlying callable. */
  Callable getUnderlyingCallable() {
    result = this.asCallable(_) or result = this.asSummarizedCallable()
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
    this = TCallable(_, result)
    or
    result = this.asSummarizedCallable().getLocation()
    or
    result = this.asFieldOrProperty().getLocation()
    or
    result = this.asCapturedVariable().getLocation()
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
}

private predicate relevantFolder(Folder f) {
  exists(NonDelegateDataFlowCall call, Location l | f = l.getFile().getParentContainer() |
    l = call.getLocation() and
    call.getARuntimeTargetCandidate(_, _).isMultiBodied()
    or
    call.getARuntimeTargetCandidate(l, _).isMultiBodied()
  )
}

private predicate adjacentFolders(Folder f1, Folder f2) {
  f1 = f2.getParentContainer()
  or
  f2 = f1.getParentContainer()
}

bindingset[f1, f2]
pragma[inline_late]
private predicate folderDist(Folder f1, Folder f2, int i) =
  shortestDistances(relevantFolder/1, adjacentFolders/2)(f1, f2, i)

/** A non-delegate C# call relevant for data flow. */
class NonDelegateDataFlowCall extends DataFlowCall, TNonDelegateCall {
  private ControlFlow::Nodes::ElementNode cfn;
  private DispatchCall dc;

  NonDelegateDataFlowCall() { this = TNonDelegateCall(cfn, dc) }

  /** Gets the underlying call. */
  DispatchCall getDispatchCall() { result = dc }

  pragma[nomagic]
  private predicate hasSourceTarget() { dc.getADynamicTarget().fromSource() }

  pragma[nomagic]
  private FlowSummary::SummarizedCallable getASummarizedCallableTarget() {
    // Only use summarized callables with generated summaries in case
    // we are not able to dispatch to a source declaration.
    exists(boolean static |
      result = this.getATarget(static) and
      not (
        result.applyGeneratedModel() and
        this.hasSourceTarget()
      )
    |
      static = false
      or
      static = true and not result instanceof RuntimeCallable
    )
  }

  pragma[nomagic]
  DataFlowCallable getARuntimeTargetCandidate(Location l, Callable c) {
    c = result.asCallable(l) and
    c = getCallableForDataFlow(dc.getADynamicTarget())
  }

  pragma[nomagic]
  private DataFlowCallable getAMultiBodiedRuntimeTargetCandidate(Callable c, int distance) {
    result.isMultiBodied() and
    exists(Location l | result = this.getARuntimeTargetCandidate(l, c) |
      inSameFile(l, this.getLocation()) and
      distance = -1
      or
      folderDist(l.getFile().getParentContainer(),
        this.getLocation().getFile().getParentContainer(), distance)
    )
  }

  pragma[nomagic]
  override DataFlowCallable getARuntimeTarget() {
    // For calls to multi-bodied methods, we restrict the viable targets to those
    // that are closest to the call site, measured by file-system distance.
    exists(Callable c |
      result =
        min(DataFlowCallable cand, int distance |
          cand = this.getAMultiBodiedRuntimeTargetCandidate(c, distance)
        |
          cand order by distance
        )
    )
    or
    result = this.getARuntimeTargetCandidate(_, _) and
    not result.isMultiBodied()
    or
    result.asSummarizedCallable() = this.getASummarizedCallableTarget()
  }

  /** Gets a static or dynamic target of this call. */
  Callable getATarget(boolean static) {
    result = dc.getADynamicTarget().getUnboundDeclaration() and static = false
    or
    result = dc.getAStaticTarget().getUnboundDeclaration() and
    static = true and
    // In reflection calls, _all_ methods with matching names and arities are considered
    // static targets, so we need to exclude them
    not dc.isReflection()
  }

  override ControlFlow::Nodes::ElementNode getControlFlowNode() { result = cfn }

  override DataFlow::ExprNode getNode() { result.getControlFlowNode() = cfn }

  override DataFlowCallable getEnclosingCallable() { result.getAControlFlowNode() = cfn }

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

  override DataFlowCallable getEnclosingCallable() { result.getAControlFlowNode() = cfn }

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
