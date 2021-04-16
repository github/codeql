private import ruby
private import codeql_ruby.CFG
private import DataFlowPrivate

newtype TReturnKind =
  TNormalReturnKind() or
  TBreakReturnKind()

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
 * A value returned from a callable using a `break` statement.
 */
class BreakReturnKind extends ReturnKind, TBreakReturnKind {
  override string toString() { result = "break" }
}

class DataFlowCallable = CfgScope;

class DataFlowCall extends CfgNodes::ExprNodes::CallCfgNode {
  DataFlowCallable getEnclosingCallable() { result = this.getScope() }

  DataFlowCallable getCallable() {
    // TODO: this is a placeholder that finds a method with the same name, iff it's uniquely named.
    result =
      unique(DataFlowCallable c | c.(Method).getName() = this.getNode().(MethodCall).getMethodName())
  }
}

/** Gets a viable run-time target for the call `call`. */
DataFlowCallable viableCallable(DataFlowCall call) { none() }

/**
 * Holds if the set of viable implementations that can be called by `call`
 * might be improved by knowing the call context. This is the case if the
 * qualifier accesses a parameter of the enclosing callable `c` (including
 * the implicit `self` parameter).
 */
predicate mayBenefitFromCallContext(DataFlowCall call, Callable c) { none() }

/**
 * Gets a viable dispatch target of `call` in the context `ctx`. This is
 * restricted to those `call`s for which a context might make a difference.
 */
DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) { none() }
