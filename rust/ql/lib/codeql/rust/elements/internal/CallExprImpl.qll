/**
 * This module provides a hand-modifiable wrapper around the generated class `CallExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.CallExpr
private import codeql.rust.elements.PathExpr

/**
 * INTERNAL: This module contains the customizable definition of `CallExpr` and should not
 * be referenced directly.
 */
module Impl {
  private import rust
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
   * A function call expression. For example:
   * ```rust
   * foo(42);
   * foo::<u32, u64>(42);
   * foo[0](42);
   * foo(1) = 4;
   * ```
   */
  class CallExpr extends Generated::CallExpr {
    override string toStringImpl() { result = this.getFunction().toAbbreviatedString() + "(...)" }

    override Callable getStaticTarget() {
      // If this call is to a trait method, e.g., `Trait::foo(bar)`, then check
      // if type inference can resolve it to the correct trait implementation.
      result = TypeInference::resolveMethodCallTarget(this)
      or
      not exists(TypeInference::resolveMethodCallTarget(this)) and
      result = getResolvedFunction(this)
    }

    /** Gets the struct that this call resolves to, if any. */
    Struct getStruct() { result = getResolvedFunction(this) }

    /** Gets the variant that this call resolves to, if any. */
    Variant getVariant() { result = getResolvedFunction(this) }

    pragma[nomagic]
    private PathResolution::ItemNode getResolvedFunctionAndPos(int pos) {
      result = getResolvedFunction(this) and
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
}
