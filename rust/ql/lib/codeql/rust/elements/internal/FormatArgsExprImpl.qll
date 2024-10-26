/**
 * This module provides a hand-modifiable wrapper around the generated class `FormatArgsExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.FormatArgsExpr
private import codeql.rust.elements.Format

/**
 * INTERNAL: This module contains the customizable definition of `FormatArgsExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A FormatArgsExpr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class FormatArgsExpr extends Generated::FormatArgsExpr {
    /**
     * Gets the `index`th format of this `FormatArgsExpr`'s formatting template (0-based).
     */
    Format getFormat(int index) {
      result =
        rank[index + 1](Format f, int i | f.getParent() = this and f.getIndex() = i | f order by i)
    }
  }
}
