/**
 * This module provides a hand-modifiable wrapper around the generated class `SlicePat`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.SlicePat

/**
 * INTERNAL: This module contains the customizable definition of `SlicePat` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A slice pattern. For example:
   * ```rust
   * match x {
   *     [1, 2, 3, 4, 5] => "ok",
   *     [1, 2, ..] => "fail",
   *     [x, y, .., z, 7] => "fail",
   * }
   * ```
   */
  class SlicePat extends Generated::SlicePat {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
