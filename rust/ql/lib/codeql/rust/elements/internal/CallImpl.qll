private import rust

module Impl {
  private import codeql.rust.internal.typeinference.TypeInference as TypeInference
  private import codeql.rust.elements.internal.ExprImpl::Impl as ExprImpl
  private import codeql.rust.elements.internal.InvocationExprImpl::Impl as InvocationExprImpl

  /**
   * A call.
   *
   * Either
   *
   * - a `CallExpr` that is _not_ an instantiation of a tuple struct or a tuple variant,
   * - a `MethodCallExpr`,
   * - an `Operation` that targets an overloadable operator, or
   * - an `IndexExpr`.
   */
  abstract class Call extends InvocationExprImpl::InvocationExpr {
    /**
     * Gets the argument at position `pos` of this call.
     *
     * Examples:
     * ```rust
     * foo(42, "bar");    // `42` is argument 0 and `"bar"` is argument 1
     * foo.bar(42);       // `foo` is receiver and `42` is argument 0
     * Foo::bar(foo, 42); // `foo` is receiver and `42` is argument 0
     * x + y;             // `x` is receiver and `y` is argument 0
     * -x;                // `x` is receiver
     * x[y];              // `x` is receiver and `y` is argument 0
     * ```
     */
    final Expr getArgument(ArgumentPosition pos) {
      result = this.getPositionalArgument(pos.asPosition())
      or
      pos.isSelf() and
      result = this.(MethodCall).getReceiver()
    }

    /** Gets an argument of this call. */
    Expr getAnArgument() { result = this.getArgument(_) }

    /**
     * Gets the `i`th positional argument of this call.
     *
     * Examples:
     * ```rust
     * foo(42, "bar");    // `42` is argument 0 and `"bar"` is argument 1
     * foo.bar(42);       // `42` is argument 0
     * Foo::bar(foo, 42); // `42` is argument 0
     * x + y;             // `y` is argument 0
     * -x;                // no positional arguments
     * x[y];              // `y` is argument 0
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
    Function getStaticTarget() { result = TypeInference::resolveCallTarget(this, _) }

    /** Gets the name of the function called, if any. */
    string getTargetName() { result = this.getStaticTarget().getName().getText() }

    /** Gets a runtime target of this call, if any. */
    pragma[nomagic]
    Function getARuntimeTarget() {
      result.hasImplementation() and
      (
        result = TypeInference::resolveCallTarget(this, _)
        or
        result.implements(TypeInference::resolveCallTarget(this, true))
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
     * foo(42, "bar");    // no receiver
     * foo.bar(42);       // `foo` is receiver
     * Foo::bar(foo, 42); // `foo` is receiver
     * x + y;             // `x` is receiver
     * -x;                // `x` is receiver
     * x[y];              // `x` is receiver
     * ```
     */
    Expr getReceiver() { none() }
  }
}
