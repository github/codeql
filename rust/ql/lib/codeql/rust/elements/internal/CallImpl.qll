private import rust
private import codeql.rust.internal.TypeInference as TypeInference
private import codeql.rust.elements.internal.ExprImpl::Impl as ExprImpl

module Impl {
  /**
   * A call expression.
   *
   * Either a `CallExpr`, a `MethodCallExpr`, an `Operation`, or an `IndexExpr`.
   */
  abstract class Call extends ExprImpl::Expr {
    /** Gets the `i`th positional argument of this call, if any. */
    Expr getArgument(int i) { none() }

    // todo: remove once internal query has been updated
    Expr getArg(int i) { result = this.getArgument(i) }

    /** Gets a positional argument of this call, if any. */
    Expr getAnArgument() { result = this.getArgument(_) }

    /** Gets the number of positional arguments of this call. */
    int getNumberOfArguments() { result = count(Expr arg | arg = this.getArgument(_)) }

    // todo: remove once internal query has been updated
    int getNumberOfArgs() { result = this.getNumberOfArguments() }

    /**
     * Gets the receiver of this call, if any.
     *
     * This is either an actual receiver of a method call, the first operand of an operation,
     * or the base expression of an index expression.
     */
    Expr getReceiver() { none() }

    /** Gets the static target (function or tuple struct/variant) of this call, if any. */
    Addressable getStaticTarget() { result = TypeInference::resolveCallTarget(this) }

    /** Gets the name of the method called, if any. */
    string getMethodName() {
      result = any(Function m | m = this.getStaticTarget() and m.hasSelfParam()).getName().getText()
    }

    /** Gets a runtime target of this call, if any. */
    pragma[nomagic]
    Function getARuntimeTarget() {
      result.hasImplementation() and
      (
        result = this.getStaticTarget()
        or
        result.implements(this.getStaticTarget())
      )
    }
  }
}
