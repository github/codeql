/**
 * This module provides a hand-modifiable wrapper around the generated class `BoxPat`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.BoxPat

/**
 * INTERNAL: This module contains the customizable definition of `BoxPat` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A box pattern. For example:
   * ```rust
   * match x {
   *     box Option::Some(y) => y,
   *     box Option::None => 0,
   * };
   * ```
   */
  class BoxPat extends Generated::BoxPat {
    override string toString() { result = "box " + this.getPat().toAbbreviatedString() }
  }
}
