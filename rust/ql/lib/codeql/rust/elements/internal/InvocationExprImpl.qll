private import rust

module Impl {
  private import codeql.rust.internal.typeinference.TypeInference as TypeInference
  private import codeql.rust.elements.internal.ExprImpl::Impl as ExprImpl

  private newtype TArgumentPosition =
    TPositionalArgumentPosition(int i) {
      i in [0 .. max([any(ParamList l).getNumberOfParams(), any(ArgList l).getNumberOfArgs()]) - 1]
    } or
    TSelfArgumentPosition()

  /** An argument position in a call. */
  class ArgumentPosition extends TArgumentPosition {
    /** Gets the index of the argument in the call, if this is a positional argument. */
    int asPosition() { this = TPositionalArgumentPosition(result) }

    /** Holds if this call position is a self argument. */
    predicate isSelf() { this instanceof TSelfArgumentPosition }

    /** Gets a string representation of this argument position. */
    string toString() {
      result = this.asPosition().toString()
      or
      this.isSelf() and result = "self"
    }
  }

  /**
   * An expression with arguments.
   *
   * Either a `CallExpr`, a `MethodCallExpr`, an `Operation`, or an `IndexExpr`.
   */
  abstract class InvocationExpr extends ExprImpl::Expr {
    /**
     * Gets the `i`th syntactical argument of this expression.
     *
     * Examples:
     * ```rust
     * foo(42, "bar");    // `42` is syntactic argument 0 and `"bar"` is syntactic argument 1
     * foo.bar(42);       // `42` is syntactic argument 0
     * Foo::bar(foo, 42); // `foo` is syntactic argument 0 and `42` is syntactic argument 1
     * Option::Some(x);   // `x` is syntactic argument 0
     * x + y;             // `x` is syntactic argument 0 and `y` is syntactic argument 1
     * -x;                // `x` is syntactic argument 0
     * x[y];              // `x` is syntactic argument 0 and `y` is syntactic argument 1
     * ```
     */
    Expr getSyntacticPositionalArgument(int i) { none() }

    /**
     * Gets the syntactic receiver of this expression, if any.
     *
     * Examples:
     * ```rust
     * foo(42, "bar");    // no syntactic receiver
     * foo.bar(42);       // `foo` is syntactic receiver
     * Foo::bar(foo, 42); // no syntactic receiver
     * Option::Some(x);   // no syntactic receiver
     * x + y;             // no syntactic receiver
     * -x;                // no syntactic receiver
     * x[y];              // no syntactic receiver
     * ```
     */
    Expr getSyntacticReceiver() { none() }

    /**
     * Gets the argument at syntactic position `pos` of this expression.
     *
     * Examples:
     * ```rust
     * foo(42, "bar");    // `42` is syntactic argument 0 and `"bar"` is syntactic argument 1
     * foo.bar(42);       // `foo` is syntactic receiver and `42` is syntactic argument 0
     * Foo::bar(foo, 42); // `foo` is syntactic argument 0 and `42` is syntactic argument 1
     * Option::Some(x);   // `x` is syntactic argument 0
     * x + y;             // `x` is syntactic argument 0 and `y` is syntactic argument 1
     * -x;                // `x` is syntactic argument 0
     * x[y];              // `x` is syntactic argument 0 and `y` is syntactic argument 1
     * ```
     */
    final Expr getSyntacticArgument(ArgumentPosition pos) {
      result = this.getSyntacticPositionalArgument(pos.asPosition())
      or
      pos.isSelf() and
      result = this.getSyntacticReceiver()
    }

    /** Gets a syntactic argument of this expression. */
    Expr getASyntacticArgument() { result = this.getSyntacticArgument(_) }

    /** Gets the number of syntactic arguments of this expression. */
    int getNumberOfSyntacticArguments() {
      result = count(Expr arg | arg = this.getSyntacticArgument(_))
    }

    /** Gets the resolved target (function or tuple struct/variant), if any. */
    Addressable getResolvedTarget() { result = TypeInference::resolveCallTarget(this, _) }
  }
}
