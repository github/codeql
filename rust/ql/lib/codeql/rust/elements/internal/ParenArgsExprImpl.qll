/**
 * This module provides a hand-modifiable wrapper around the generated class `ParenArgsExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ParenArgsExpr

/**
 * INTERNAL: This module contains the customizable definition of `ParenArgsExpr` and should not
 * be referenced directly.
 */
module Impl {
  private import rust
  private import codeql.rust.elements.internal.CallExprImpl::Impl as CallExprImpl
  private import codeql.rust.elements.internal.CallLikeExprImpl::Impl as CallLikeExprImpl
  private import codeql.rust.internal.PathResolution as PathResolution

  pragma[nomagic]
  Path getBasePath(ParenArgsExpr pae) { result = pae.getBase().(PathExpr).getPath() }

  pragma[nomagic]
  PathResolution::ItemNode getResolvedBase(ParenArgsExpr pae) {
    result = PathResolution::resolvePath(getBasePath(pae))
  }

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An expression with parenthesized arguments. For example:
   * ```rust
   * foo(42);
   * foo::<u32, u64>(42);
   * foo[0](42);
   * foo(1) = 4;
   * Option::Some(42);
   * ```
   */
  class ParenArgsExpr extends Generated::ParenArgsExpr, CallLikeExprImpl::CallLikeExpr {
    override string toStringImpl() { result = this.getBase().toAbbreviatedString() + "(...)" }

    override Expr getArgument(int i) { result = this.getArgList().getArg(i) }

    /** Gets the struct that this call resolves to, if any. */
    Struct getStruct() { result = getResolvedBase(this) }

    /** Gets the variant that this call resolves to, if any. */
    Variant getVariant() { result = getResolvedBase(this) }

    pragma[nomagic]
    private PathResolution::ItemNode getResolvedFunctionAndPos(int pos) {
      result = getResolvedBase(this) and
      exists(this.getArgList().getArg(pos))
    }

    /**
     * Gets the tuple field that matches the `pos`th argument of this call, if any.
     *
     * For example, if this call is `Option::Some(42)`, then the tuple field matching
     * `42` is the first field of `Option::Some`.
     */
    pragma[nomagic]
    TupleField getTupleField(int pos) {
      exists(PathResolution::ItemNode i | i = this.getResolvedFunctionAndPos(pos) |
        result.isStructField(i, pos) or
        result.isVariantField(i, pos)
      )
    }
  }

  private class ParenArgsCallExpr extends CallExprImpl::CallExpr instanceof ParenArgsExpr {
    ParenArgsCallExpr() {
      forall(Addressable target | target = super.getResolvedTarget() | target instanceof Callable)
    }

    private predicate isMethodCall() { super.getResolvedTarget() instanceof Method }

    override Expr getArgument(int i) {
      if this.isMethodCall()
      then result = super.getArgList().getArg(i + 1)
      else result = super.getArgList().getArg(i)
    }

    override Expr getReceiver() { this.isMethodCall() and result = super.getArgList().getArg(0) }
  }
}
