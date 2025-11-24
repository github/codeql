private import rust

module Impl {
  private import codeql.rust.internal.TypeInference as TypeInference
  private import codeql.rust.elements.internal.ExprImpl::Impl as ExprImpl
  private import codeql.rust.elements.internal.ArgsExprImpl::Impl as ArgsExprImpl

  /**
   * A call.
   *
   * Either
   *
   * - a `CallExpr` that is _not_ an instantiation of a tuple struct or a tuple enum variant,
   * - a `MethodCallExpr`,
   * - an `Operation` that targets an overloadable operator, or
   * - an `IndexExpr`.
   */
  abstract class Call extends ArgsExprImpl::ArgsExpr {
    // todo: remove once internal query has been updated
    Expr getReceiver() { none() }

    /**
     * Gets the `i`th positional argument of this call, if any.
     *
     * Examples:
     * ```rust
     * foo(42, "bar"); // `42` is argument 0 and `"bar"` is argument 1
     * foo.bar(42);    // `42` is argument 0
     * x + y;          // `y` is argument 0
     * x[y];           // `y` is argument 0
     * ```
     */
    Expr getPositionalArgument(int i) { none() }

    /** Gets a positional argument of this expression. */
    Expr getAPositionalArgument() { result = this.getPositionalArgument(_) }

    /** Gets the number of positional arguments of this expression. */
    int getNumberOfPositionalArguments() {
      result = count(Expr arg | arg = this.getPositionalArgument(_))
    }

    /** Gets the resolved target of this call, if any. */
    Function getStaticTarget() { result = TypeInference::resolveCallTarget(this) }

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

  /**
   * A method call.
   *
   * Either
   *
   * - a `CallExpr` where we can resolve the target as a method,
   * - a `MethodCallExpr`,
   * - an `Operation` that targets an overloadable operator, or
   * - an `IndexExpr`.
   */
  abstract class MethodCall extends Call {
    /**
     * Gets the receiver of this method call.
     *
     * Examples:
     * ```rust
     * foo(42, "bar"); // no receiver
     * foo.bar(42);    // `foo` is receiver
     * x + y;          // `x` is receiver
     * x[y];           // `x` is receiver
     * ```
     */
    override Expr getReceiver() { none() }
  }
}
