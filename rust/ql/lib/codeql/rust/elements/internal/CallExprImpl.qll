/**
 * This module provides a hand-modifiable wrapper around the generated class `CallExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.CallExpr

/**
 * INTERNAL: This module contains the customizable definition of `CallExpr` and should not
 * be referenced directly.
 */
module Impl {
  private import rust
  private import codeql.rust.elements.internal.ArgsExprImpl::Impl as ArgsExprImpl
  private import codeql.rust.elements.internal.CallImpl::Impl as CallImpl
  private import codeql.rust.internal.PathResolution as PathResolution
  private import codeql.rust.internal.TypeInference as TypeInference

  pragma[nomagic]
  Path getFunctionPath(CallExpr ce) { result = ce.getFunction().(PathExpr).getPath() }

  pragma[nomagic]
  PathResolution::ItemNode getResolvedFunction(CallExpr ce) {
    result = PathResolution::resolvePath(getFunctionPath(ce))
  }

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * NOTE: Consider using `Call` instead, as that excludes call expressions that are
   * instantiations of tuple structs and tuple variants.
   *
   * A call expression. For example:
   * ```rust
   * foo(42);
   * foo::<u32, u64>(42);
   * foo[0](42);
   * Option::Some(42); // tuple variant instantiation
   * ```
   */
  class CallExpr extends Generated::CallExpr, ArgsExprImpl::ArgsExpr {
    override string toStringImpl() { result = this.getFunction().toAbbreviatedString() + "(...)" }

    override Expr getSyntacticArgument(int i) { result = this.getArgList().getArg(i) }

    // todo: remove once internal query has been updated
    Expr getArg(int i) { result = this.getSyntacticArgument(i) }

    // todo: remove once internal query has been updated
    int getNumberOfArgs() { result = this.getNumberOfSyntacticArguments() }
  }

  /**
   * A call expression that is _not_ an instantiation of a tuple struct or a tuple enum variant.
   *
   * For example:
   * ```rust
   * foo(42);
   * foo::<u32, u64>(42);
   * foo[0](42);
   * foo(1) = 4;
   * ```
   */
  class CallExprCall extends CallExpr, CallImpl::Call {
    CallExprCall() {
      not this instanceof TupleStructExpr and
      not this instanceof TupleVariantExpr
    }

    override Expr getPositionalArgument(int i) { result = super.getSyntacticArgument(i) }
  }

  /**
   * A call expression that is a _potential_ method call.
   *
   * Note: In order to prevent the AST layer from relying on the type inference
   * layer, we do not check that the resolved target is a method in the charpred,
   * instead we check this in `getPositionalArgument` and `getReceiver`.
   */
  class CallExprMethodCall extends CallExprCall, CallImpl::MethodCall {
    CallExprMethodCall() { not this instanceof ClosureCallExpr }

    private predicate isInFactMethodCall() { this.getResolvedTarget() instanceof Method }

    override Expr getPositionalArgument(int i) {
      if this.isInFactMethodCall()
      then result = this.getSyntacticArgument(i + 1)
      else result = this.getSyntacticArgument(i)
    }

    override Expr getReceiver() {
      this.isInFactMethodCall() and
      result = super.getSyntacticArgument(0)
    }
  }

  /**
   * A call expression that instantiates a tuple struct.
   *
   * For example:
   * ```rust
   * struct S(u32, u64);
   * let s = S(42, 84);
   * ```
   */
  class TupleStructExpr extends CallExpr {
    private Struct struct;

    TupleStructExpr() { struct = getResolvedFunction(this) }

    /** Gets the struct that is instantiated. */
    Struct getStruct() { result = struct }

    /** Gets the `i`th tuple field of the instantiated struct. */
    pragma[nomagic]
    TupleField getTupleField(int i) { result = this.getStruct().getTupleField(i) }

    override string getAPrimaryQlClass() { result = "TupleStructExpr" }
  }

  /**
   * A call expression that instantiates a tuple enum variant.
   *
   * For example:
   * ```rust
   * enum E {
   *     V(u32, u64),
   * }
   * let e = E::V(42, 84);
   * ```
   */
  class TupleVariantExpr extends CallExpr {
    private Variant variant;

    TupleVariantExpr() { variant = getResolvedFunction(this) }

    /** Gets the variant that is instantiated. */
    Variant getVariant() { result = variant }

    /** Gets the `i`th tuple field of the instantiated variant. */
    pragma[nomagic]
    TupleField getTupleField(int i) { result = this.getVariant().getTupleField(i) }

    override string getAPrimaryQlClass() { result = "TupleVariantExpr" }
  }
}
