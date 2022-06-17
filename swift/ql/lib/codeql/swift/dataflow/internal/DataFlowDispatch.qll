private import swift
private import DataFlowPrivate
private import DataFlowPublic
private import codeql.swift.controlflow.ControlFlowGraph

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
  AbstractFunctionDecl func;

  DataFlowCallable() { this = TDataFlowFunc(func) }

  /** Gets a textual representation of this callable. */
  string toString() { result = func.toString() }

  /** Gets the location of this callable. */
  Location getLocation() { result = func.getLocation() }
}

/**
 * A call. This includes calls from source code, as well as call(back)s
 * inside library callables with a flow summary.
 */
class DataFlowCall extends ExprNode {
  DataFlowCall() { this.asExpr() instanceof CallExpr }

  /** Gets the enclosing callable. */
  DataFlowCallable getEnclosingCallable() { result = TDataFlowFunc(this.getCfgNode().getScope()) }
}

cached
private module Cached {
  cached
  newtype TDataFlowCallable = TDataFlowFunc(CfgScope scope)

  /** Gets a viable run-time target for the call `call`. */
  cached
  DataFlowCallable viableCallable(DataFlowCall call) {
    result = TDataFlowFunc(call.asExpr().(CallExpr).getStaticTarget())
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

/**
 * Holds if the set of viable implementations that can be called by `call`
 * might be improved by knowing the call context.
 */
predicate mayBenefitFromCallContext(DataFlowCall call, DataFlowCallable c) { none() }

/**
 * Gets a viable dispatch target of `call` in the context `ctx`. This is
 * restricted to those `call`s for which a context might make a difference.
 */
DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) { none() }

/** A parameter position. */
class ParameterPosition extends TParameterPosition {
  /** Gets a textual representation of this position. */
  string toString() { none() }
}

class PositionalParameterPosition extends ParameterPosition, TPositionalParameter {
  int getIndex() { this = TPositionalParameter(result) }
}

/** An argument position. */
class ArgumentPosition extends TArgumentPosition {
  /** Gets a textual representation of this position. */
  string toString() { none() }
}

class PositionalArgumentPosition extends ArgumentPosition, TPositionalArgument {
  int getIndex() { this = TPositionalArgument(result) }
}

/** Holds if arguments at position `apos` match parameters at position `ppos`. */
pragma[inline]
predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) {
  ppos instanceof TThisParameter and
  apos instanceof TThisArgument
  or
  ppos.(PositionalParameterPosition).getIndex() = apos.(PositionalArgumentPosition).getIndex()
}
