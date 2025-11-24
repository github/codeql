private import rust

module Impl {
  private import codeql.rust.internal.TypeInference as TypeInference
  private import codeql.rust.elements.internal.ExprImpl::Impl as ExprImpl

  /**
   * An expression with arguments.
   *
   * Either a `CallExpr`, a `MethodCallExpr`, an `Operation`, or an `IndexExpr`.
   */
  abstract class ArgsExpr extends ExprImpl::Expr {
    /**
     * Gets the `i`th syntactic argument of this expression.
     *
     * Examples:
     * ```rust
     * foo(42, "bar"); // `42` is argument 0 and `"bar"` is argument 1
     * foo.bar(42);    // `foo` is argument 0 and `42` is argument 1
     * x + y;          // `x` is argument 0 and `y` is argument 1
     * x[y];           // `x` is argument 0 and `y` is argument 1
     * ```
     */
    Expr getSyntacticArgument(int i) { none() }

    /** Gets an argument of this expression. */
    Expr getASyntacticArgument() { result = this.getSyntacticArgument(_) }

    /** Gets the number of arguments of this expression. */
    int getNumberOfSyntacticArguments() {
      result = count(Expr arg | arg = this.getSyntacticArgument(_))
    }

    /** Gets the resolved target (function or tuple struct/variant), if any. */
    Addressable getResolvedTarget() { result = TypeInference::resolveCallTarget(this) }
  }
}
