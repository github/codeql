/**
 * This module provides a hand-modifiable wrapper around the generated class `TupleStructPat`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.TupleStructPat

/**
 * INTERNAL: This module contains the customizable definition of `TupleStructPat` and should not
 * be referenced directly.
 */
module Impl {
  private import rust
  private import codeql.rust.internal.PathResolution as PathResolution

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A tuple struct pattern. For example:
   * ```rust
   * match x {
   *     Tuple("a", 1, 2, 3) => "great",
   *     Tuple(.., 3) => "fine",
   *     Tuple(..) => "fail",
   * };
   * ```
   */
  class TupleStructPat extends Generated::TupleStructPat {
    override string toString() { result = this.getPath().toAbbreviatedString() + "(...)" }

    pragma[nomagic]
    private PathResolution::ItemNode getResolvedPath(int pos) {
      result = PathResolution::resolvePath(this.getPath()) and
      exists(this.getField(pragma[only_bind_into](pos)))
    }

    /** Gets the tuple field that matches the `pos`th pattern of this pattern. */
    pragma[nomagic]
    TupleField getTupleField(int pos) {
      exists(PathResolution::ItemNode i | i = this.getResolvedPath(pos) |
        result.isStructField(i, pos) or
        result.isVariantField(i, pos)
      )
    }
  }
}
