/**
 * This module provides a hand-modifiable wrapper around the generated class `LiteralPat`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.LiteralPat

/**
 * INTERNAL: This module contains the customizable definition of `LiteralPat` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A literal pattern. For example:
   * ```rust
   * match x {
   *     42 => "ok",
   *     _ => "fail",
   * }
   * ```
   */
  class LiteralPat extends Generated::LiteralPat {
    override string toString() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() { result = this.getLiteral().getTrimmedText() }
  }
}
