private import swift
private import DataFlowPrivate
private import DataFlowPublic
private import codeql.swift.controlflow.ControlFlowGraph
private import codeql.swift.controlflow.CfgNodes
private import codeql.swift.controlflow.internal.Scope
private import FlowSummaryImpl as FlowSummaryImpl
private import codeql.swift.dataflow.FlowSummary as FlowSummary

newtype TReturnKind =
  TNormalReturnKind() or
  TParamReturnKind(int i) { exists(ParamDecl param | param.getIndex() = i) }

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

/**
 * A value returned from a callable using an `inout` parameter.
 */
class ParamReturnKind extends ReturnKind, TParamReturnKind {
  int index;

  ParamReturnKind() { this = TParamReturnKind(index) }

  int getIndex() { result = index }

  override string toString() { result = "param(" + index + ")" }
}

/**
 * A callable. This includes callables from source code, as well as callables
 * defined in library code.
 */
class DataFlowCallable extends TDataFlowCallable {
  /** Gets the location of this callable. */
  Location getLocation() { none() } // overridden in subclasses

  /** Gets a textual representation of this callable. */
  string toString() { none() } // overridden in subclasses

  CfgScope asSourceCallable() { this = TDataFlowFunc(result) }

  FlowSummary::SummarizedCallable asSummarizedCallable() { this = TSummarizedCallable(result) }

  Callable::TypeRange getUnderlyingCallable() {
    result = this.asSummarizedCallable() or result = this.asSourceCallable()
  }
}

cached
newtype TDataFlowCall =
  TNormalCall(ApplyExprCfgNode call) or
  TPropertyGetterCall(PropertyGetterCfgNode getter) or
  TPropertySetterCall(PropertySetterCfgNode setter) or
  TPropertyObserverCall(PropertyObserverCfgNode observer) or
  TKeyPathCall(KeyPathApplicationExprCfgNode keyPathApplication) or
  TSummaryCall(
    FlowSummaryImpl::Public::SummarizedCallable c, FlowSummaryImpl::Private::SummaryNode receiver
  ) {
    FlowSummaryImpl::Private::summaryCallbackRange(c, receiver)
  }

/**
 * A call. This includes calls from source code, as well as call(back)s
 * inside library callables with a flow summary.
 */
class DataFlowCall extends TDataFlowCall {
  /** Gets the enclosing callable. */
  DataFlowCallable getEnclosingCallable() { none() }

  /** Gets the underlying source code call, if any. */
  ApplyExprCfgNode asCall() { none() }

  /** Gets the underlying key-path application node, if any. */
  KeyPathApplicationExprCfgNode asKeyPath() { none() }

  /**
   * Gets the i'th argument of call.class
   * The qualifier is considered to have index `-1`.
   */
  CfgNode getArgument(int i) { none() }

  final CfgNode getAnArgument() { result = this.getArgument(_) }

  /** Gets a textual representation of this call. */
  string toString() { none() }

  /** Gets the location of this call. */
  Location getLocation() { none() }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

private class NormalCall extends DataFlowCall, TNormalCall {
  private ApplyExprCfgNode apply;

  NormalCall() { this = TNormalCall(apply) }

  override ApplyExprCfgNode asCall() { result = apply }

  override CfgNode getArgument(int i) {
    i = -1 and
    result = apply.getQualifier()
    or
    result = apply.getArgument(i)
  }

  override DataFlowCallable getEnclosingCallable() { result = TDataFlowFunc(apply.getScope()) }

  override string toString() { result = apply.toString() }

  override Location getLocation() { result = apply.getLocation() }
}

private class KeyPathCall extends DataFlowCall, TKeyPathCall {
  private KeyPathApplicationExprCfgNode apply;

  KeyPathCall() { this = TKeyPathCall(apply) }

  override KeyPathApplicationExprCfgNode asKeyPath() { result = apply }

  override CfgNode getArgument(int i) {
    i = -1 and
    result = apply.getBase()
  }

  override DataFlowCallable getEnclosingCallable() { result = TDataFlowFunc(apply.getScope()) }

  override string toString() { result = apply.toString() }

  override Location getLocation() { result = apply.getLocation() }
}

class PropertyGetterCall extends DataFlowCall, TPropertyGetterCall {
  private PropertyGetterCfgNode getter;

  PropertyGetterCall() { this = TPropertyGetterCall(getter) }

  override CfgNode getArgument(int i) {
    i = -1 and
    result = getter.getBase()
  }

  override DataFlowCallable getEnclosingCallable() { result = TDataFlowFunc(getter.getScope()) }

  PropertyGetterCfgNode getGetter() { result = getter }

  override string toString() { result = getter.toString() }

  override Location getLocation() { result = getter.getLocation() }

  Accessor getAccessor() { result = getter.getAccessor() }
}

class PropertySetterCall extends DataFlowCall, TPropertySetterCall {
  private PropertySetterCfgNode setter;

  PropertySetterCall() { this = TPropertySetterCall(setter) }

  override CfgNode getArgument(int i) {
    i = -1 and
    result = setter.getBase()
    or
    i = 0 and
    result = setter.getSource()
  }

  override DataFlowCallable getEnclosingCallable() { result = TDataFlowFunc(setter.getScope()) }

  PropertySetterCfgNode getSetter() { result = setter }

  override string toString() { result = setter.toString() }

  override Location getLocation() { result = setter.getLocation() }

  Accessor getAccessor() { result = setter.getAccessor() }
}

class PropertyObserverCall extends DataFlowCall, TPropertyObserverCall {
  private PropertyObserverCfgNode observer;

  PropertyObserverCall() { this = TPropertyObserverCall(observer) }

  override CfgNode getArgument(int i) {
    i = -1 and
    result = observer.getBase()
    or
    i = 0 and
    result = observer.getSource()
  }

  override DataFlowCallable getEnclosingCallable() { result = TDataFlowFunc(observer.getScope()) }

  PropertyObserverCfgNode getObserver() { result = observer }

  override string toString() { result = observer.toString() }

  override Location getLocation() { result = observer.getLocation() }

  Accessor getAccessor() { result = observer.getAccessor() }
}

class SummaryCall extends DataFlowCall, TSummaryCall {
  private FlowSummaryImpl::Public::SummarizedCallable c;
  private FlowSummaryImpl::Private::SummaryNode receiver;

  SummaryCall() { this = TSummaryCall(c, receiver) }

  /** Gets the data flow node that this call targets. */
  FlowSummaryImpl::Private::SummaryNode getReceiver() { result = receiver }

  override DataFlowCallable getEnclosingCallable() { result = TSummarizedCallable(c) }

  override string toString() { result = "[summary] call to " + receiver + " in " + c }

  override UnknownLocation getLocation() { any() }
}

cached
private module Cached {
  cached
  newtype TDataFlowCallable =
    TDataFlowFunc(CfgScope scope) { not scope instanceof FlowSummary::SummarizedCallable } or
    TSummarizedCallable(FlowSummary::SummarizedCallable c)

  /** Gets a viable run-time target for the call `call`. */
  cached
  DataFlowCallable viableCallable(DataFlowCall call) {
    result = TDataFlowFunc(call.asCall().getStaticTarget())
    or
    result = TDataFlowFunc(call.(PropertyGetterCall).getAccessor())
    or
    result = TDataFlowFunc(call.(PropertySetterCall).getAccessor())
    or
    result = TDataFlowFunc(call.(PropertyObserverCall).getAccessor())
    or
    result = TSummarizedCallable(call.asCall().getStaticTarget())
  }

  private class SourceCallable extends DataFlowCallable, TDataFlowFunc {
    CfgScope scope;

    SourceCallable() { this = TDataFlowFunc(scope) }

    override string toString() { result = scope.toString() }

    override Location getLocation() { result = scope.getLocation() }
  }

  private class SummarizedCallable extends DataFlowCallable, TSummarizedCallable {
    FlowSummary::SummarizedCallable sc;

    SummarizedCallable() { this = TSummarizedCallable(sc) }

    override string toString() { result = sc.toString() }

    override Location getLocation() { result = sc.getLocation() }
  }

  cached
  newtype TArgumentPosition =
    TThisArgument() or
    // we rely on default exprs generated in the caller for ordering
    TPositionalArgument(int n) { n = any(Argument arg).getIndex() }

  cached
  newtype TParameterPosition =
    TThisParameter() or
    TPositionalParameter(int n) { n = any(Argument arg).getIndex() }
}

import Cached

/** A parameter position. */
class ParameterPosition extends TParameterPosition {
  /** Gets a textual representation of this position. */
  string toString() { none() }
}

class PositionalParameterPosition extends ParameterPosition, TPositionalParameter {
  int getIndex() { this = TPositionalParameter(result) }

  override string toString() { result = this.getIndex().toString() }
}

class ThisParameterPosition extends ParameterPosition, TThisParameter {
  override string toString() { result = "this" }
}

/** An argument position. */
class ArgumentPosition extends TArgumentPosition {
  /** Gets a textual representation of this position. */
  string toString() { none() }
}

class PositionalArgumentPosition extends ArgumentPosition, TPositionalArgument {
  int getIndex() { this = TPositionalArgument(result) }

  override string toString() { result = this.getIndex().toString() }
}

class ThisArgumentPosition extends ArgumentPosition, TThisArgument {
  override string toString() { result = "this" }
}

/** Holds if arguments at position `apos` match parameters at position `ppos`. */
pragma[inline]
predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) {
  ppos instanceof TThisParameter and
  apos instanceof TThisArgument
  or
  ppos.(PositionalParameterPosition).getIndex() = apos.(PositionalArgumentPosition).getIndex()
}
