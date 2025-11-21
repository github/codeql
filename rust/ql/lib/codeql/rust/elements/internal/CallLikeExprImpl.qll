private import rust

module Impl {
  private import codeql.rust.internal.TypeInference as TypeInference
  private import codeql.rust.elements.internal.ExprImpl::Impl as ExprImpl

  /**
   * A call-like expression.
   *
   * Either a `ParenArgsExpr`, a `MethodCallExpr`, an `Operation`, or an `IndexExpr`.
   */
  abstract class CallLikeExpr extends ExprImpl::Expr {
    /** Gets the `i`th positional argument of this call, if any. */
    Expr getArgument(int i) { none() }

    /** Gets a positional argument of this call, if any. */
    Expr getAnArgument() { result = this.getArgument(_) }

    /** Gets the number of positional arguments of this call. */
    int getNumberOfArguments() { result = count(Expr arg | arg = this.getArgument(_)) }

    /**
     * Gets the receiver of this call, if any.
     *
     * This is either an actual receiver of a method call, the first operand of an operation,
     * or the base expression of an index expression.
     */
    Expr getReceiver() { none() }

    /** Gets the resolved target (function or tuple struct/variant) of this call, if any. */
    Addressable getResolvedTarget() { result = TypeInference::resolveCallTarget(this) }
  }
}
