/**
 * Provides PHP-specific data flow dispatch logic.
 */

private import codeql.php.AST
private import DataFlowPrivate

newtype TReturnKind = TNormalReturnKind()

/**
 * A return kind. A return kind describes how a value can be returned
 * from a callable.
 */
abstract class ReturnKind extends TReturnKind {
  abstract string toString();
}

/** A normal return (via `return` statement or expression body). */
class NormalReturnKind extends ReturnKind, TNormalReturnKind {
  override string toString() { result = "return" }
}

/**
 * Gets a node that can read the value returned from `call` with return kind `kind`.
 */
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) { call = result.getCall(kind) }

newtype TDataFlowCallable = TCallable(Callable c)

/** A callable (function, method, closure, arrow function). */
class DataFlowCallable extends TDataFlowCallable {
  Callable c;

  DataFlowCallable() { this = TCallable(c) }

  Callable asCallable() { result = c }

  string toString() { result = c.toString() }

  Location getLocation() { result = c.getLocation() }
}

newtype TDataFlowCall = TNormalCall(Call call)

/** A data flow call. */
class DataFlowCall extends TDataFlowCall {
  Call call;

  DataFlowCall() { this = TNormalCall(call) }

  Call asCall() { result = call }

  DataFlowCallable getEnclosingCallable() {
    result.asCallable() = call.getParent*().(Callable)
  }

  string toString() { result = call.toString() }

  Location getLocation() { result = call.getLocation() }
}

/**
 * Gets a viable callable for the call `c`.
 *
 * This is currently a simple name-based resolution. A full implementation
 * would require type inference and class hierarchy analysis.
 */
DataFlowCallable viableCallable(DataFlowCall c) {
  exists(FunctionCallExpr fce, FunctionDef fd |
    fce = c.asCall() and
    fd.getNameString() = fce.getFunctionName() and
    result = TCallable(fd)
  )
}

predicate mayBenefitFromCallContext(DataFlowCall call) { none() }

DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) { none() }

newtype TParameterPosition = TPositionalParameterPosition(int i) { i in [0 .. 20] }

/** A parameter position. */
class ParameterPosition extends TParameterPosition {
  int pos;

  ParameterPosition() { this = TPositionalParameterPosition(pos) }

  int asPositional() { result = pos }

  string toString() { result = pos.toString() }
}

newtype TArgumentPosition = TPositionalArgumentPosition(int i) { i in [0 .. 20] }

/** An argument position. */
class ArgumentPosition extends TArgumentPosition {
  int pos;

  ArgumentPosition() { this = TPositionalArgumentPosition(pos) }

  int asPositional() { result = pos }

  string toString() { result = pos.toString() }
}

predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) {
  ppos.asPositional() = apos.asPositional()
}
