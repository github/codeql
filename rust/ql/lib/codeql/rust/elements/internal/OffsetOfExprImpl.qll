/**
 * This module provides a hand-modifiable wrapper around the generated class `OffsetOfExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.OffsetOfExpr

/**
 * INTERNAL: This module contains the customizable definition of `OffsetOfExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   *  An `offset_of` expression. For example:
   * ```rust
   * builtin # offset_of(Struct, field);
   * ```
   */
  class OffsetOfExpr extends Generated::OffsetOfExpr {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
