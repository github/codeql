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
  private import PathResolution as PathResolution

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
    override string toString() { result = this.getFunction().toAbbreviatedString() + "(...)" }

    pragma[nomagic]
    private PathResolution::ItemNode getResolvedFunction(int pos) {
      result = PathResolution::resolvePath(this.getFunction().(PathExpr).getPath()) and
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
      exists(PathResolution::ItemNode i | i = this.getResolvedFunction(pos) |
        result.isStructField(i, pos) or
        result.isVariantField(i, pos)
      )
    }
  }
}
