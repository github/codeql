/**
 * This module provides a hand-modifiable wrapper around the generated class `LetElse`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.LetElse

/**
 * INTERNAL: This module contains the customizable definition of `LetElse` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A LetElse. For example:
   * ```rust
   * todo!()
   * ```
   */
  class LetElse extends Generated::LetElse {
    override string toString() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() { result = "else {...}" }
  }
}
